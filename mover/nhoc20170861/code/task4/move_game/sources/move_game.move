module move_game::move_game {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

    use faucet_coin::faucet_coin::FAUCET_COIN;

    const REWARD: u64 = 1_000_000_000;

    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>
    }

    public struct Admin has key, store {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(Game {
                id: object::new(ctx),
                balance: balance::zero<FAUCET_COIN>()
            }
        );

        transfer::public_transfer(Admin {
            id: object::new(ctx)
        }, ctx.sender());
    }

    entry fun deposit(
        move_game: &mut Game,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64
    ) {
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut move_game.balance, split_balance);
    }

    entry fun withdraw(
        move_game: &mut Game,
        _: &Admin,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let withdraw_coin = coin::take(&mut move_game.balance, amount, ctx);
        transfer::public_transfer(withdraw_coin, ctx.sender());
    }

    entry fun play(
        move_game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let mut random_generator = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut random_generator);
        
        if (flag == guess) {
            let reward = coin::take(&mut move_game.balance, REWARD, ctx);
            coin::join(coin, reward);
        } else {
            deposit(move_game, coin, REWARD);
        }
    }

}