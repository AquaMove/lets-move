module swap::NguyenHiu {
    use my_coin::my_coin::MY_COIN as TOKEN_X;
    use my_faucet_coin::my_faucet_coin::MY_FAUCET_COIN as TOKEN_Y;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin, TreasuryCap};

    // Constants
    const DEFAULT_ONE: u64 = 100;

    // Error codes
    const EINVALID_WISH: u64 = 0;

    public struct NGUYENHIU has drop {}

    public struct Pool has key {
        id: UID,
        token_x: Balance<TOKEN_X>,
        token_y: Balance<TOKEN_Y>,
        lp_token: Balance<NGUYENHIU>,
        treasury_cap: TreasuryCap<NGUYENHIU>,
        one: u64,
    }

    fun init(witness: NGUYENHIU, ctx: &mut TxContext) {
        // Create Liquidity Provider Token
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            5,
            b"NH",
            b"NguyenHiu token",
            b"Liquidity Provider Token",
            option::none(),
            ctx,
        );
        transfer::public_freeze_object(metadata);

        // Create Pool object
        transfer::share_object(Pool {
            id: object::new(ctx),
            token_x: balance::zero<TOKEN_X>(),
            token_y: balance::zero<TOKEN_Y>(),
            lp_token: balance::zero<NGUYENHIU>(),
            treasury_cap: treasury_cap,
            one: DEFAULT_ONE,
        });
    }

    public entry fun add_liquidity(
        pool: &mut Pool,
        x: Coin<TOKEN_X>,
        y: Coin<TOKEN_Y>,
        ctx: &mut TxContext,
    ) {
        let total_supply = coin::total_supply(&pool.treasury_cap);
        let x_value = x.value();
        let y_value = y.value();
        let one = pool.one;

        // Calculate the LP Token to return back
        let lp_token: u64;
        if (total_supply == 0) {
            lp_token = x.value() + y.value();
        } else {
            lp_token =
                (total_supply * std::u64::min(x_value * one / pool.token_x.value(), y_value * one / pool.token_y.value())) / one;
        };

        // Get added tokens
        coin::put(&mut pool.token_x, x);
        coin::put(&mut pool.token_y, y);

        // Mint LP Token
        let minted_lp_token = coin::mint(&mut pool.treasury_cap, lp_token, ctx);

        // Transfer to liquidity provider
        transfer::public_transfer(minted_lp_token, ctx.sender());
    }

    public entry fun remove_liquidity(
        pool: &mut Pool,
        liquidity_tokens: Coin<NGUYENHIU>,
        ctx: &mut TxContext,
    ) {
        let one = pool.one;

        // Calculate share ratio
        let share = liquidity_tokens.value()*one / coin::total_supply(&pool.treasury_cap);

        // Calculate the number of returned token X
        let return_token_x = share * pool.token_x.value() / one;
        let return_token_y = share * pool.token_y.value() / one;

        // Burn LP Tokens
        coin::burn(&mut pool.treasury_cap, liquidity_tokens);

        // Transfer back
        transfer::public_transfer(
            coin::take(&mut pool.token_x, return_token_x, ctx),
            ctx.sender(),
        );
        transfer::public_transfer(
            coin::take(&mut pool.token_y, return_token_y, ctx),
            ctx.sender(),
        );
    }

    public entry fun calc_swap_x_to_y(pool: &Pool, x: u64): u64 {
        // Get reserves
        let x_value = pool.token_x.value();
        let y_value = pool.token_y.value();

        // Calculate tokens after change
        let new_reserve_x = x_value + x;
        let new_reserve_y = x_value * y_value / new_reserve_x;
        let return_token_y = y_value - new_reserve_y;
        return_token_y
    }

    public entry fun swap_x_to_y(pool: &mut Pool, x: Coin<TOKEN_X>, min_amount: u64, ctx: &mut TxContext) {
        // Get return token y with x token
        let return_token_y = calc_swap_x_to_y(pool, x.value());

        // Check if the return amount satisfies the user
        assert!(return_token_y >= min_amount, EINVALID_WISH);

        // Take token x
        coin::put(&mut pool.token_x, x);

        // Return token y
        transfer::public_transfer(
            coin::take(
                &mut pool.token_y,
                return_token_y,
                ctx,
            ),
            ctx.sender(),
        );
    }

    public entry fun calc_swap_y_to_x(pool: &Pool, y: u64): u64 {
        // Get reserves
        let x_value = pool.token_x.value();
        let y_value = pool.token_y.value();

        // Calculate tokens after change
        let new_reserve_y = y_value + y;
        let new_reserve_x = x_value * y_value / new_reserve_y;
        let return_token_x = x_value - new_reserve_x;
        return_token_x
    }

    public entry fun swap_y_to_x(pool: &mut Pool, y: Coin<TOKEN_Y>, min_amount: u64, ctx: &mut TxContext) {
        // Get return token y with x token
        let return_token_x = calc_swap_y_to_x(pool, y.value());

        // Check if the return amount satisfies the user
        assert!(return_token_x >= min_amount, EINVALID_WISH);

        // Take token y
        coin::put(&mut pool.token_y, y);

        // Return token x
        transfer::public_transfer(
            coin::take(
                &mut pool.token_x,
                return_token_x,
                ctx,
            ),
            ctx.sender(),
        );
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(NGUYENHIU {}, ctx)
    }
}
