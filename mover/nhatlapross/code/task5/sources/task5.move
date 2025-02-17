module 0x0::task5 {
    use faucet_coin::faucet_coin::FAUCET_COIN;
    use alvin_coin::alvin_coin::ALVIN_COIN;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};

    public struct Pool has key {
        id: UID,
        my_coin: Balance<ALVIN_COIN>,
        faucet_coin: Balance<FAUCET_COIN>
    }

    fun init(ctx: &mut TxContext){
        let pool = Pool{
            id: object::new(ctx),
            my_coin: balance::zero<ALVIN_COIN>(),
            faucet_coin: balance::zero<FAUCET_COIN>()
        };

        transfer::share_object(pool);
    }
    fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<ALVIN_COIN>, faucet_coin: Coin<FAUCET_COIN>){
        pool.my_coin.join(my_coin.into_balance());
        pool.my_coin.join(faucet_coin.into_balance());
    }

    public fun deposit_my_coin(pool: &mut Pool, user_coin: Coin<ALVIN_COIN>,ctx: &mut TxContext){
        coin::put(pool.my_coin, user_coin);
    }

    public fun deposit_my_coin(pool: &mut Pool, user_coin: Coin<ALVIN_COIN>,ctx: &mut TxContext){
        coin::put(&mut pool.faucet_coin, user_coin);
    }

    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<ALVIN_COIN>, ctx: &mut TxContext){
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(pool.faucet_coin, amount,ctx);
        
        transfer::public_transfer(output_coin, ctx.sender());
    }

    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, my_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext){
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.faucet_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount,ctx);
        
        transfer::public_transfer(output_coin, ctx.sender());
    }

    
}
