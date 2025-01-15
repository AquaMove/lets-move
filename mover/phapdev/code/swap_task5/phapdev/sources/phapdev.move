module 0x0::phapdev {

    use sui::balance::{Self, Balance};
    use my_coin::mycoin::{MYCOIN};
    use faucet_coin::faucetmycoin::{FAUCETMYCOIN };
    use sui::coin::{Self, Coin};
    use sui::transfer;

    public struct Pool has key {
        id: UID,
        my_coin: Balance<MYCOIN>,
        faucet_coin: Balance<FAUCETMYCOIN>,
    }

    fun init(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<MYCOIN>(),
            faucet_coin: balance::zero<FAUCETMYCOIN>(),
        };
        transfer::share_object(pool);
    }

    entry fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<MYCOIN>, faucet_coin: Coin<FAUCETMYCOIN>) {
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    public entry fun deposit_my_coin(pool: &mut Pool, user_coin: Coin<MYCOIN>, ctx: &mut TxContext) {
        coin::put(&mut pool.my_coin, user_coin);
    }

    public entry fun deposit_faucet_coin(pool: &mut Pool, user_coin: Coin<FAUCETMYCOIN>, ctx: &mut TxContext) {
        coin::put(&mut pool.faucet_coin, user_coin);
    }

    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<MYCOIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.faucet_coin, amount,ctx);
        transfer::public_transfer(output_coin, ctx.sender());
    } 

    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, faucet_coin: Coin<FAUCETMYCOIN>, ctx: &mut TxContext) {
        let amount = faucet_coin.value();
        assert!(amount > 0, 0);

        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount,ctx);
        transfer::public_transfer(output_coin, ctx.sender());
    }   
}
