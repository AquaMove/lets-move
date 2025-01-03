module move_game::move_game {
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::random::{Self, Random};
    use faucet_coin::faucet_coin::{FAUCET_COIN};

    const ERR_INSUFFICIENT_BALANCE: u64 = 1;
    const ERR_INVALID_ADMIN: u64 = 2;
    const ERR_DEPOSIT_AMOUNT_ZERO: u64 = 3;


    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>,
    }
    
    public struct Admin has key {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::public_share_object(Game {
            id: object::new(ctx),
            balance: balance::zero<FAUCET_COIN>(),
        });
        transfer::transfer(Admin {
            id: object::new(ctx)
        }, ctx.sender());
    }

    public entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64) {
        assert!(amount > 0, ERR_DEPOSIT_AMOUNT_ZERO);
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut game.balance, split_balance);
    }

    public entry fun withdraw(game: &mut Game, _: &Admin, amount: u64, ctx: &mut TxContext) {
        assert!(balance::value(&game.balance) >= amount, ERR_INSUFFICIENT_BALANCE);
        let cash = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(cash, ctx.sender());
    }

    public entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let mut generator = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut generator);
        let play_cost = 100000000;
        if (coin::value(coin) < play_cost){
            abort(0)
        };
         let split_balance = balance::split(coin::balance_mut(coin), play_cost);
        balance::join(&mut game.balance, split_balance);

        if (flag == guess) {
            let reward_amount = 2 * play_cost; 
              if (balance::value(&game.balance) >= reward_amount) {
                let reward = coin::take(&mut game.balance, reward_amount, ctx);
                coin::join(coin, reward);
            }
        } 
    }
}