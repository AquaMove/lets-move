
module task4::task4 {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Random};
    use faucet_coin::faucet_coin::FAUCET_COIN;


    public struct Game has key {
        id: UID,
        balance: Balance<FAUCET_COIN>
    }

    public struct Admin has key {
        id: UID,
    }

    fun init(ctx: &mut TxContext){
        transfer::share_object(Game {
            id: object::new(ctx),
            balance: balance::zero<FAUCET_COIN>()
        });


        transfer::transfer(
            Admin{
                id: object::new(ctx)
            }
            , ctx.sender())

    }

    entry fun deposit(
        game: &mut Game,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64
    ){ 
        let split_balance = balance::split(coin::balance_mut(coin), amount);

        balance::join(&mut game.balance, split_balance);
    }


    entry fun withdraw(
        game: &mut Game,
        _: &Admin,
        amount: u64,
        ctx: &mut TxContext
    ){ 
        let cash = coin::take(&mut game.balance, amount, ctx);

        transfer::public_transfer(cash, ctx.sender());
    }

    entry fun play(
        game: &mut Game,
        rnd: &Random, 
        guess: bool,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let flag = generate_dice_roll(rnd, ctx);

        if(flag == guess) {
            let reward = coin::take(&mut game.balance, 1_000, ctx);
            coin::join(coin, reward);
        } else {
            deposit(game, coin, 1_000)
        }
    }

    fun generate_dice_roll(random: &Random, ctx: &mut TxContext): bool {
        let mut gen = random.new_generator(ctx);
        (gen.generate_bool())
    }
}
