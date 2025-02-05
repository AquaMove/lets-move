/*
/// Module: niko1444_swap
module niko1444_swap::niko1444_swap;
*/

module 0x0::niko1444_swap{

    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use niko1444_swap::faucet_coin::FAUCET_COIN;
    use niko1444_swap::my_coin::MY_COIN;

    public struct Pool has key {
        id: UID,
        my_coin: Balance<MY_COIN>,
        faucet_coin: Balance<FAUCET_COIN>,
    }

    fun init(ctx: &mut TxContext){
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<MY_COIN>(),
            faucet_coin: balance::zero<FAUCET_COIN>(),
        };

        transfer::share_object(pool);
    }

    fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<FAUCET_COIN>){
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    public fun deposit_my_coin(pool: &mut Pool, user_coin: Coin<MY_COIN>, ctx: &mut TxContext){
        coin::put(&mut pool.my_coin, user_coin);
    }

    public fun deposit_faucet_coin(pool: &mut Pool, user_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext){
        coin::put(&mut pool.faucet_coin, user_coin);
    }

    // 1 MY_COIN = 1 FAUCET_COIN
    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>, ctx: &mut TxContext){
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.faucet_coin, amount, ctx);

        transfer::public_transfer(output_coin, ctx.sender());
        
    }

    // 1 FAUCET_COIN = 1 MY_COIN
    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, faucet_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext){
        let amount = faucet_coin.value();
        assert!(amount > 0, 0);

        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount, ctx);

        transfer::public_transfer(output_coin, ctx.sender());
    }
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


