module move_game::move_game {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};
    use faucet_coin::faucet_coin::{FAUCET_COIN};
    use std::string::{Self, String};

    const ERR_INSUFFICIENT_BALANCE: u64 = 1;
    const ERR_DEPOSIT_AMOUNT_ZERO: u64 = 2;

    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>,
        github_id: String,
    }

    fun init(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero<FAUCET_COIN>(),
            github_id: string::utf8(b"le-dat"),
        };
        transfer::share_object(game);
    }

    public entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64) {
        assert!(amount > 0, ERR_DEPOSIT_AMOUNT_ZERO);
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut game.balance, split_balance);
    }

    public entry fun withdraw(game: &mut Game, amount: u64, ctx: &mut TxContext) {
        assert!(balance::value(&game.balance) >= amount, ERR_INSUFFICIENT_BALANCE);
        let cash = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(cash, ctx.sender());
    }

    #[allow(lint(public_random))]
    public entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: u8,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let mut generator = random::new_generator(rnd, ctx);
        let random_number = random::generate_u8(&mut generator) % 10 + 1; // Generates a number between 1 and 10
        let play_cost = 100000000;
        if (coin::value(coin) < play_cost){
            abort(0)
        };
        let split_balance = balance::split(coin::balance_mut(coin), play_cost);
        balance::join(&mut game.balance, split_balance);

        if (random_number == guess) {
            let reward_amount = 5 * play_cost; 
            if (balance::value(&game.balance) >= reward_amount) {
                let reward = coin::take(&mut game.balance, reward_amount, ctx);
                coin::join(coin, reward);
            }
        } 
    }
}
