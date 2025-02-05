module task5::task5;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use my_coin::faucet_coin::FAUCET_COIN;
use my_coin::my_coin::MY_COIN;

const ELessEqual0: u64 = 0;

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

public fun add_token(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<FAUCET_COIN>) {
    pool.my_coin.join(my_coin.into_balance());
    pool.faucet_coin.join(faucet_coin.into_balance());
}

public fun deposit_mycoin(pool: &mut Pool, usr_coin: Coin<MY_COIN>) {
    coin::put(&mut pool.my_coin, usr_coin);
}

public fun deposit_faucetcoin(pool: &mut Pool, usr_coin: Coin<FAUCET_COIN>) {
    coin::put(&mut pool.faucet_coin, usr_coin);
}

entry fun my_coin_faucet(pool: &mut Pool, my_coin: Coin<MY_COIN>, ctx: &mut TxContext) {
    let amount = my_coin.value();
    assert!(amount > 0, ELessEqual0);

    pool.my_coin.join(my_coin.into_balance());
    let output = coin::take(&mut pool.faucet_coin, amount, ctx);
    transfer::public_transfer(output, ctx.sender());
}

entry fun faucet_my_coin(pool: &mut Pool, usr_coin: Coin<FAUCET_COIN>, ctx: &mut TxContext) {
    let amount = usr_coin.value();
    assert!(amount > 0, ELessEqual0);

    pool.faucet_coin.join(usr_coin.into_balance());
    let output = coin::take(&mut pool.my_coin, amount, ctx);
    transfer::public_transfer(output, ctx.sender());
}
