/*
/// Module: move_swap
module move_swap::move_swap;
Author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module move_swap::move_swap {
    use sui::balance::{Self, Balance};
    use my_coin::my_coin::MY_COIN;
    use faucet_coin::faucet_coin::FAUCET_COIN;
    use sui::coin::{Self, Coin};

    /// A liquidity pool that stores both MY_COIN and FAUCET_COIN
    public struct Pool has key {
        id: UID,
        my_coin: Balance<MY_COIN>,
        faucet_coin: Balance<FAUCET_COIN>,
    }

    /// Initializes a new pool
    fun init(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<MY_COIN>(),
            faucet_coin: balance::zero<FAUCET_COIN>(),
        };

        transfer::share_object(pool);
    }

    /// This function is used for initializing the pool with some amount of both MY_COIN and FAUCET_COIN. 
    public entry fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<FAUCET_COIN>) {
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    /// Adds liquidity to the pool in the form of MY_COIN
    public entry fun deposit_my_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>) {
        pool.my_coin.join(my_coin.into_balance());
    }

    /// Adds liquidity to the pool in the form of FAUCET_COIN
    public entry fun deposit_faucet_coin(pool: &mut Pool, faucet_coin: Coin<FAUCET_COIN>) {
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    /// Swaps MY_COIN for FAUCET_COIN
    /// This function is used to swap MY_COIN for FAUCET_COIN. It takes a certain amount of MY_COIN from the user and 
    /// gives them the same amount of FAUCET_COIN from the pool. It then adjusts the pool's balance accordingly.
    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 1);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.faucet_coin, amount, ctx);
        transfer::public_transfer(output_coin, tx_context::sender(ctx));
    }

    /// Swaps FAUCET_COIN for MY_COIN
    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, faucet_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext) {
        let amount = faucet_coin.value();
        assert!(amount > 0, 1);

        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount, ctx);
        transfer::public_transfer(output_coin, tx_context::sender(ctx));
    } 
} 

