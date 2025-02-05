module task5::swap {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use faucet_coin::musashi::MUSASHI;
    use my_coin::my_coin::MY_COIN;

    public struct Pool has key {
        id: UID,
        my_coin: Balance<MY_COIN>,
        faucet_coin: Balance<MUSASHI>,
    }

    fun init(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<MY_COIN>(),
            faucet_coin: balance::zero<MUSASHI>(),
        };

        transfer::share_object(pool);
    }

    public entry fun add_liquidity(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<MUSASHI>) {
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    public entry fun deposit_my_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>) {
        pool.my_coin.join(my_coin.into_balance());
    }

    public entry fun deposit_faucet_coin(pool: &mut Pool, faucet_coin: Coin<MUSASHI>) {
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 1);

        pool.my_coin.join(my_coin.into_balance());

        let output_faucet_coin = coin::take(&mut pool.faucet_coin, amount, ctx);
        transfer::public_transfer(output_faucet_coin, tx_context::sender(ctx));
    }

    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, faucet_coin: Coin<MUSASHI>, ctx: &mut TxContext) {
        let amount = faucet_coin.value();
        assert!(amount > 0, 1);

        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_my_coin = coin::take(&mut pool.my_coin, amount, ctx);
        transfer::public_transfer(output_my_coin, tx_context::sender(ctx));
    }
}