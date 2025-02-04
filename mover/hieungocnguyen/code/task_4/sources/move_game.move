module 0x0::move_game {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

    use faucet_coin::faucet_coin::FAUCET_COIN;

    public struct Game has key {
        id: UID,
        balance: Balance<FAUCET_COIN>
    }

    public struct Admin has key {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            Game {
                id: object::new(ctx),
                balance: balance::zero<FAUCET_COIN>()
            }
        );

        transfer::transfer(
            Admin {id: object::new(ctx)},
            ctx.sender()
        )

    }

    entry fun deposit(
        game: &mut Game,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64
    ) {
        let split_balance = balance::split(coin::balance_mut(coin), amount);

        balance::join(&mut game.balance, split_balance);
    }

    entry fun withdraw(
        game: &mut Game,
        _: &Admin,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let cash = coin::take(&mut game.balance, amount, ctx);

        transfer::public_transfer(cash, ctx.sender());
    }

    entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: u8,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let mut gen = random::new_generator(rnd, ctx);
        let numberRnd = random::generate_u8_in_range(&mut gen, 1, 3);

        //1: Kéo, 2: Búa, 3: Bao
        if ((numberRnd == 1 && guess == 2) || (numberRnd == 2 && guess == 3) || (numberRnd == 3 && guess == 1)) {
            let reward = coin::take(&mut game.balance, 100_000_000, ctx);
            coin::join(coin, reward);
        }
        else if (numberRnd != guess) {
            deposit(game, coin, 100_000_000)
        }
    }

}
