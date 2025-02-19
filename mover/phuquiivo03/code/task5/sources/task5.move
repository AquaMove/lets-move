
module task5::task5 {
    use task5::qcoin::{QCOIN};
    use task5::defai::{DEFAI};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::transfer;


    public struct Pool has key {
        id: UID,
        my_coin: Balance<QCOIN>,
        faucet_coin: Balance<DEFAI>,
    }

    //   khởi tạo Pool
    fun init(ctx: &mut TxContext) {
        let pool = Pool {
            id: object::new(ctx),
            my_coin: balance::zero<QCOIN>(),
            faucet_coin: balance::zero<DEFAI>(),
        };
        transfer::share_object(pool);
    }

    // thêm tiền vào Pool
    entry fun add_money_to_pool(pool: &mut Pool, my_coin: Coin<QCOIN>, faucet_coin: Coin<DEFAI>) {
        pool.my_coin.join(my_coin.into_balance());
        pool.faucet_coin.join(faucet_coin.into_balance());
    }

    // nạp_COIN vào Pool
    public entry fun deposit_coin(pool: &mut Pool, user_coin: Coin<QCOIN>, ctx: &mut TxContext) {
        coin::put(&mut pool.my_coin, user_coin);
    }

    // nạp Y vào Pool
    public entry fun deposit_faucet_coin(pool: &mut Pool, user_coin: Coin<DEFAI>, ctx: &mut TxContext) {
        coin::put(&mut pool.faucet_coin, user_coin);
    }


    // Hoán đổi_COIN sang Y với tỷ lệ 1:1
    public entry fun swap_coin_to_faucet_coin(pool: &mut Pool, my_coin: Coin<QCOIN>, ctx: &mut TxContext) {
        let amount = my_coin.value();
        assert!(amount > 0, 0);

        pool.my_coin.join(my_coin.into_balance());

        let output_coin = coin::take(&mut pool.faucet_coin, amount,ctx);
        transfer::public_transfer(output_coin, ctx.sender());
    } 

    public entry fun swap_faucet_coin_to_coin(pool: &mut Pool, faucet_coin: Coin<DEFAI>, ctx: &mut TxContext) {
        let amount = faucet_coin.value();
        assert!(amount > 0, 0);

        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_coin = coin::take(&mut pool.my_coin, amount,ctx);
        transfer::public_transfer(output_coin, ctx.sender());
    }   
}