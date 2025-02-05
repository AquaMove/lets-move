module game::game {
    use 0x2::random::{Self, Random};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use my_faucet_coin::my_faucet_coin::{MY_FAUCET_COIN as FC};
    use std::string::{Self, String};

    // Error codes
    const EPlayerInvalidAmount: u64 = 0;
    const EPoolInvalidAmount: u64 = 1;
    const EGameIsOff: u64 = 2;
    const EGameIsRunning: u64 = 3;

    // Constants
    const DEFAULT_MIN: u8 = 1;
    const DEFAULT_MAX: u8 = 10;
    const DEFAULT_PIVOT: u8 = 5;

    public struct Game has key {
        id: UID,
        title: String,
        balance: Balance<FC>,
        active: bool,
        min: u8,
        max: u8,
        pivot: u8
    }

    public struct Admin has key {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(Game {
            id: object::new(ctx),
            title: string::utf8(b"NguyenHiu Game"),
            balance: balance::zero<FC>(),
            active: false,
            min: DEFAULT_MIN,
            max: DEFAULT_MAX,
            pivot: DEFAULT_PIVOT
        });

        transfer::transfer(Admin {
            id: object::new(ctx)
        }, ctx.sender());
    }

    public entry fun deposit(
        _: &Admin,
        game: &mut Game,
        bag: Coin<FC> ,
    ) {
        coin::put(&mut game.balance, bag);
    }

    public entry fun withdraw(
        _: &Admin,
        game: &mut Game,
        ctx: &mut TxContext
    ){ 
        // Check if the game is stopped before withdrawing
        assert!(!game.active, EGameIsRunning);
        
        // Take coins from the pool
        let total = game.balance.value();
        let cash = coin::take(&mut game.balance, total, ctx);
        transfer::public_transfer(cash, ctx.sender());
    }

    public entry fun get_active_status(game: &Game): bool {
        game.active
    }

    public entry fun start_game(_: &Admin, game: &mut Game) {
        game.active = true
    }

    public entry fun end_game(_: &Admin, game: &mut Game) {
        game.active = false
    }

    entry fun play(
        r: &Random, 
        game: &mut Game, 
        p_coin: &mut Coin<FC>, 
        amount: u64, 
        up: bool,
        ctx: &mut TxContext
    ) {
        // Check if the game is running
        assert!(game.active, EGameIsOff);

        // Player doesn't have enough coin
        assert!(p_coin.value() >= amount, EPlayerInvalidAmount);

        // Game's Pool doens't have enough coin
        assert!(amount*2 <= game.balance.value(), EPoolInvalidAmount);

        let mut generator = random::new_generator(r, ctx);
        let rand_num = random::generate_u8_in_range(&mut generator, game.min, game.max);

        // Take bet money
        balance::join(
            &mut game.balance, 
            balance::split(
                coin::balance_mut(p_coin),
                amount
            )
        );

        // Player wins ==> Double money
        if ((rand_num > game.pivot && up) || (rand_num < game.pivot && !up)) {
            coin::join(
                p_coin,
                coin::take(&mut game.balance, amount*2, ctx),
            );
        } 
    }

    #[test_only]
    public fun init_game(ctx: &mut TxContext) {
        init(ctx);
    }   

    #[test_only]
    public fun get_game_balance(game: &Game): u64 {
        game.balance.value()
    }
}