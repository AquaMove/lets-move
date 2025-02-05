/*
/// Module: move_swap
module move_swap::move_swap;
*/
module move_swap::move_swap {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::table::{Self, Table};

    // Errors
    const EInsufficientLiquidity: u64 = 0;
    const EZeroAmount: u64 = 1;

    public struct LiquidityPool<phantom X, phantom Y> has key {
        id: UID,
        balance_x: Balance<X>,
        balance_y: Balance<Y>,
        lp_supply: u64
    }

    public struct LPToken<phantom X, phantom Y> has key {
        id: UID,
        amount: u64
    }

    fun init(_ctx: &mut TxContext) {}

    public entry fun create_pool<X, Y>(
        coin_x: Coin<X>,
        coin_y: Coin<Y>,
        ctx: &mut TxContext
    ) {
        let balance_x = coin::into_balance(coin_x);
        let balance_y = coin::into_balance(coin_y);
        let lp_supply = (balance::value(&balance_x) * balance::value(&balance_y)) as u64;

        let pool = LiquidityPool<X, Y> {
            id: object::new(ctx),
            balance_x,
            balance_y,
            lp_supply
        };

        let lp_token = LPToken<X, Y> {
            id: object::new(ctx),
            amount: lp_supply
        };

        transfer::share_object(pool);
        transfer::transfer(lp_token, tx_context::sender(ctx));
    }

    public entry fun swap_x_to_y<X, Y>(
        pool: &mut LiquidityPool<X, Y>,
        coin_x: Coin<X>,
        ctx: &mut TxContext
    ) {
        let x_amount = coin::value(&coin_x);
        assert!(x_amount > 0, EZeroAmount);

        let x_reserve = balance::value(&pool.balance_x);
        let y_reserve = balance::value(&pool.balance_y);

        let y_out = calculate_output(x_amount, x_reserve, y_reserve);
        assert!(y_out > 0 && y_out <= y_reserve, EInsufficientLiquidity);

        balance::join(&mut pool.balance_x, coin::into_balance(coin_x));
        let coin_y = coin::from_balance(balance::split(&mut pool.balance_y, y_out), ctx);
        transfer::public_transfer(coin_y, tx_context::sender(ctx));
    }

    public entry fun swap_y_to_x<X, Y>(
        pool: &mut LiquidityPool<X, Y>,
        coin_y: Coin<Y>,
        ctx: &mut TxContext
    ) {
        let y_amount = coin::value(&coin_y);
        assert!(y_amount > 0, EZeroAmount);

        let x_reserve = balance::value(&pool.balance_x);
        let y_reserve = balance::value(&pool.balance_y);

        let x_out = calculate_output(y_amount, y_reserve, x_reserve);
        assert!(x_out > 0 && x_out <= x_reserve, EInsufficientLiquidity);

        balance::join(&mut pool.balance_y, coin::into_balance(coin_y));
        let coin_x = coin::from_balance(balance::split(&mut pool.balance_x, x_out), ctx);
        transfer::public_transfer(coin_x, tx_context::sender(ctx));
    }

    fun calculate_output(amount_in: u64, reserve_in: u64, reserve_out: u64): u64 {
        let fees = 30; // 0.3% fee
        let amount_with_fee = (amount_in as u128) * (1000 - fees);
        let numerator = amount_with_fee * (reserve_out as u128);
        let denominator = (reserve_in as u128) * 1000 + amount_with_fee;
        ((numerator / denominator) as u64)
    }

    public entry fun get_reserves<X, Y>(pool: &LiquidityPool<X, Y>): (u64, u64) {
        (balance::value(&pool.balance_x), balance::value(&pool.balance_y))
    }

    public entry fun get_lp_supply<X, Y>(pool: &LiquidityPool<X, Y>): u64 {
        pool.lp_supply
    }
}