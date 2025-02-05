module my_game::my_game {

    use faucet_coin::faucet_coin::FAUCET_COIN;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};
    use std::string::{String};

    const EUserInsufficientBalance: u64 = 1;
    const EGameInsufficientBalance: u64 = 2;

    public struct Game has key {
        id: UID,
        balance: Balance<FAUCET_COIN>,
        game_name: String,
        github: String,
    }

    public struct Admin has key {
        id: UID,
    }

    
    fun init(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero<FAUCET_COIN>(),
            game_name: b"Guessing Game".to_string(),
            github: b"lamdanghoang".to_string()
        };

        transfer::share_object(game);

        let admin = Admin { id: object::new(ctx) };
        
        transfer::transfer(admin, ctx.sender());
    }

    public entry fun Deposit(
        game: &mut Game,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64
    ) {

        let coin_value = coin.value();

        assert!(coin_value >= amount, EUserInsufficientBalance);

        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut game.balance, split_balance);

    }

    public entry fun Withdraw(
        game: &mut Game,
        _: &Admin,
        amount: u64,
        ctx: &mut TxContext
    ) {
        assert!(game.balance.value() >= amount, EGameInsufficientBalance);

        let cash = coin::take(&mut game.balance, amount, ctx);

        transfer::public_transfer(cash, ctx.sender());

    }

    public entry fun Play(
        game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64,
        ctx: &mut TxContext
    ) {

        assert!(game.balance.value() >= amount, EGameInsufficientBalance);

        assert!(coin::value(coin) >= amount, EUserInsufficientBalance);

        let mut gen = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut gen);

        if (flag == guess) {
            let reward = coin::take(&mut game.balance, 2 * amount, ctx);
            coin::join(coin, reward);
        } else {
            Deposit(game, coin, amount);
        }
    }
}