module 0x0::task_4 {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};
    use 0x0::my_coin::MY_COIN;
    //use my_coin::my_coin::MY_COIN;

    // Define error
    const EInsufficientFund: u64 = 1;

    public struct Game has key {
        id: UID,
        balance: Balance<MY_COIN>
    }

    public struct Admin has key {
        id: UID,
        
    }

    fun init(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero(),
        };

        transfer::share_object(game);

        let admin = Admin {
            id: object::new(ctx)
        };
        transfer::transfer(admin, ctx.sender());
    }

    public entry fun deposit(
        game: &mut Game,
        coin: &mut Coin<MY_COIN>,
        amount: u64
    ) {
        assert!(
            coin::value(coin) >= amount,
            EInsufficientFund
        );

        let split_balance = balance::split(coin:: balance_mut(coin), amount);
        balance::join(&mut game.balance, split_balance);
    }

    public entry fun withdraw(game: &mut Game, _: &Admin, amount: u64, ctx: &mut TxContext) {
        assert!(balance::value(&game.balance) >= amount, EInsufficientFund);

        let money = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(money, ctx.sender());
    }

    public entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<MY_COIN>,
        amount: u64,
        ctx:&mut TxContext
    ) {
        assert!(
            game.balance.value() >= amount,
            EInsufficientFund
        );
        assert!(
            coin::value(coin) >= amount,
            EInsufficientFund
        );

        let mut gen = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut gen);

        if (flag == guess) {
            let reward = coin::take(&mut game.balance, 1_0000_000_000, ctx);
            coin::join(coin, reward);
        } else {
            deposit(game, coin, 1_000_000_000);
        }
    }
    
    
}



