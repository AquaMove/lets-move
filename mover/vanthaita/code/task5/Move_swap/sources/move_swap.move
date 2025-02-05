module vanthaita::move_swap {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::math;
    use faucet_coin::faucet_coin::{FAUCET_COIN};
    use move_coin::my_coin::{MY_COIN};

    const E_INVALID_SWAP: u64 = 0;
    const E_INSUFFICIENT_BALANCE: u64 = 1;
    const E_ZERO_LP_TOKEN: u64 = 2;
    const E_NOT_ADMIN: u64 = 3;


    public struct SwapPool<phantom CoinA, phantom CoinB> has key {
        id: UID,
        balance_coin_a: Balance<CoinA>,
        balance_coin_b: Balance<CoinB>,
        total_lp_token_minted: u64,
    }

    public struct SwapPoolLpToken<phantom CoinA, phantom CoinB> has key {
        id: UID,
        amount: u64,
    }

    public struct Admin has key{
        id: UID,
    }

    public entry fun create_pool(
        _: &Admin,
        coin_a: Coin<FAUCET_COIN>,
        coin_b: Coin<MY_COIN>,
        ctx: &mut TxContext,
    ) {
        let balance_a = coin::into_balance(coin_a);
        let balance_b = coin::into_balance(coin_b);

        let lp_token_amount = balance::value(&balance_a) + balance::value(&balance_b);

        let swap_pool = SwapPool<FAUCET_COIN, MY_COIN> {
            id: object::new(ctx),
            balance_coin_a: balance_a,
            balance_coin_b: balance_b,
            total_lp_token_minted: lp_token_amount,
        };
        transfer::share_object(swap_pool);
    }

    public entry fun swap_coin_a_to_coin_b(
        pool: &mut SwapPool<FAUCET_COIN, MY_COIN>,
        coin_a: Coin<FAUCET_COIN>,
        ctx: &mut TxContext,
    ) {
        let coin_a_balance = coin::value(&coin_a);
        let balance_a = &mut pool.balance_coin_a;
        let balance_b = &mut pool.balance_coin_b;

        let pool_balance_a = balance::value(balance_a);
        let pool_balance_b = balance::value(balance_b);


        let new_balance_a = pool_balance_a  + coin_a_balance;
        let amount_b_out = pool_balance_b - ((pool_balance_a * pool_balance_b) / new_balance_a);
        
        assert!(amount_b_out > 0, E_INVALID_SWAP);

        balance::join(balance_a, coin::into_balance(coin_a));
        let coin_b_out = coin::from_balance(balance::split(balance_b, amount_b_out), ctx);
        transfer::public_transfer(coin_b_out, ctx.sender());
    }

    public entry fun swap_coin_b_to_coin_a(
        pool: &mut SwapPool<FAUCET_COIN, MY_COIN>,
        coin_b: Coin<MY_COIN>,
         ctx: &mut TxContext,
    ) {
        let coin_b_balance = coin::value(&coin_b);
        let balance_a = &mut pool.balance_coin_a;
        let balance_b = &mut pool.balance_coin_b;

        let pool_balance_a = balance::value(balance_a);
        let pool_balance_b = balance::value(balance_b);

        let new_balance_b = pool_balance_b + coin_b_balance;
        let amount_a_out = pool_balance_a - ((pool_balance_a * pool_balance_b) / new_balance_b);

        assert!(amount_a_out > 0, E_INVALID_SWAP);

        balance::join(balance_b, coin::into_balance(coin_b));
        let coin_a_out = coin::from_balance(balance::split(balance_a, amount_a_out), ctx);
        transfer::public_transfer(coin_a_out, ctx.sender());
    }

    public entry fun create_lp_token(
        pool: &mut SwapPool<FAUCET_COIN, MY_COIN>,
        coin_a: Coin<FAUCET_COIN>,
        coin_b: Coin<MY_COIN>,
        ctx: &mut TxContext,
    ) {
        let amount_a = coin::value(&coin_a);
        let amount_b = coin::value(&coin_b);

        let balance_a = &mut pool.balance_coin_a;
        let balance_b = &mut pool.balance_coin_b;

        let total_amount = amount_a + amount_b;

        let lp_token_amount = if (pool.total_lp_token_minted == 0) {
            total_amount
        } else {
            let pool_balance_a = balance::value(balance_a);
            let pool_balance_b = balance::value(balance_b);
            math::divide_and_round_up((total_amount * pool.total_lp_token_minted), (pool_balance_a + pool_balance_b))
        };

        balance::join(balance_a, coin::into_balance(coin_a));
        balance::join(balance_b, coin::into_balance(coin_b));

        let lp_token = SwapPoolLpToken<FAUCET_COIN, MY_COIN> {
            id: object::new(ctx),
            amount: lp_token_amount,
        };
        pool.total_lp_token_minted = pool.total_lp_token_minted + lp_token_amount;

        transfer::transfer(lp_token, ctx.sender());
    }

    public entry fun burn_lp_token(
        pool: &mut SwapPool<FAUCET_COIN, MY_COIN>,
        lp_token: SwapPoolLpToken<FAUCET_COIN, MY_COIN>,
        ctx: &mut TxContext,
    ) {
        let lp_token_amount = lp_token.amount;
        let balance_a = &mut pool.balance_coin_a;
        let balance_b = &mut pool.balance_coin_b;

        let pool_balance_a = balance::value(balance_a);
        let pool_balance_b = balance::value(balance_b);

        assert!(lp_token_amount > 0, E_ZERO_LP_TOKEN);
        
        let total_lp_token_minted = pool.total_lp_token_minted;

        let amount_a_out = math::divide_and_round_up((lp_token_amount * pool_balance_a), total_lp_token_minted);
        let amount_b_out = math::divide_and_round_up((lp_token_amount * pool_balance_b), total_lp_token_minted);
        
        let coin_a_out = coin::from_balance(balance::split(balance_a, amount_a_out), ctx);
        let coin_b_out = coin::from_balance(balance::split(balance_b, amount_b_out), ctx);
        
        pool.total_lp_token_minted = total_lp_token_minted - lp_token_amount;
        transfer::public_transfer(coin_a_out, ctx.sender());
        transfer::public_transfer(coin_b_out, ctx.sender());
        let SwapPoolLpToken {id, amount: _ } = lp_token;
        object::delete(id);
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            Admin {
                id: object::new(ctx)
            }
            ,ctx.sender()
        )
    }
}