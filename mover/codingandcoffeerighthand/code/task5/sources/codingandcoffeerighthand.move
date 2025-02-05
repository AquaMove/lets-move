module codingandcoffeerighthand::codingandcoffeerighthand;

use faucet_coin::faucet_coin;
use my_coin::my_coin;
use sui::balance;
use sui::coin;

public struct Pool has key {
    id: UID,
    my_coin: balance::Balance<my_coin::MY_COIN>,
    faucet_coin: balance::Balance<faucet_coin::FAUCET_COIN>,
}

fun init(ctx: &mut TxContext) {
    let pool = Pool {
        id: object::new(ctx),
        my_coin: balance::zero<my_coin::MY_COIN>(),
        faucet_coin: balance::zero<faucet_coin::FAUCET_COIN>(),
    };
    transfer::share_object(pool)
}

entry fun add_money_to_pool(
    pool: &mut Pool,
    my_coin: coin::Coin<my_coin::MY_COIN>,
    faucet_coin: coin::Coin<faucet_coin::FAUCET_COIN>,
) {
    pool.my_coin.join(my_coin.into_balance());
    pool.faucet_coin.join(faucet_coin.into_balance());
}

public fun deposit_my_coin(
    pool: &mut Pool,
    user_coin: coin::Coin<my_coin::MY_COIN>,
    _ctx: &mut TxContext,
) {
    coin::put(&mut pool.my_coin, user_coin)
}

public fun deposit_faucet_coin(
    pool: &mut Pool,
    user_coin: coin::Coin<faucet_coin::FAUCET_COIN>,
    _ctx: &mut TxContext,
) {
    coin::put(&mut pool.faucet_coin, user_coin)
}

public entry fun swap_my_coin_to_faucet_coin(
    pool: &mut Pool,
    my_coin: coin::Coin<my_coin::MY_COIN>,
    ctx: &mut TxContext,
) {
    let amount = my_coin.value();
    assert!(amount > 0, 0x0);
    pool.my_coin.join(my_coin.into_balance());
    let desposit_coin = coin::take(&mut pool.faucet_coin, amount, ctx);
    transfer::public_transfer(desposit_coin, ctx.sender());
}

public entry fun swap_faucet_coin_to_my(
    pool: &mut Pool,
    faucet_coin: coin::Coin<faucet_coin::FAUCET_COIN>,
    ctx: &mut TxContext,
) {
    let amount = faucet_coin.value();
    assert!(amount > 0, 0x0);
    pool.faucet_coin.join(faucet_coin.into_balance());
    let desposit_coin = coin::take(&mut pool.my_coin, amount, ctx);
    transfer::public_transfer(desposit_coin, ctx.sender());
}
