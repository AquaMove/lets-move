
module thosanmaytinh::task5 {
    use sui::coin::{Coin, Self};
    use sui::balance::{Balance, Self};
    use my_coin::my_coin::MY_COIN;
    use faucet_coin::faucet_coin::FAUCET_COIN;

    public struct Pool has key {
        id: UID,
        my_coin: Balance<MY_COIN>,
        faucet_coin: Balance<FAUCET_COIN>
    }

    fun init(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<MY_COIN>(),
            faucet_coin: balance::zero<FAUCET_COIN>()
        };

        transfer::share_object(pool);
    }
    
    entry fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<FAUCET_COIN>) {
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    public entry fun deposit_my_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>) {
        coin::put(&mut pool.my_coin, my_coin);
    }

    public entry fun deposit_faucet_coin(pool: &mut Pool, faucet_coin: Coin<FAUCET_COIN>) {
        coin::put(&mut pool.faucet_coin, faucet_coin);
    }

    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<MY_COIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.faucet_coin, amount, ctx);
        
        transfer::public_transfer(output_coin, ctx.sender());
    }

        public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, my_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.faucet_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount, ctx);
        
        transfer::public_transfer(output_coin, ctx.sender());
    }
}