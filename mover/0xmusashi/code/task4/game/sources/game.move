module game::game {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

    use faucet_coin::musashi::MUSASHI;

    const REWARD: u64 = 1_000_000_000;

    public struct Game has key, store {
        id: UID,
        balance: Balance<MUSASHI>
    }

    public struct AdminCap has key, store {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(Game {
                id: object::new(ctx),
                balance: balance::zero<MUSASHI>()
            }
        );

        transfer::public_transfer(AdminCap {
            id: object::new(ctx)
        }, ctx.sender());
    }

    entry fun deposit(
        game: &mut Game,
        coin: &mut Coin<MUSASHI>,
        amount: u64
    ) {
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut game.balance, split_balance);
    }

    entry fun withdraw(
        game: &mut Game,
        _: &AdminCap,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let withdraw_coin = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(withdraw_coin, ctx.sender());
    }

    entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<MUSASHI>,
        ctx: &mut TxContext
    ) {
        let mut random_generator = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut random_generator);
        
        if (flag == guess) {
            let reward = coin::take(&mut game.balance, REWARD, ctx);
            coin::join(coin, reward);
        } else {
            deposit(game, coin, REWARD);
        }
    }

}