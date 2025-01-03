/*
/// Module: tuananhdohoang
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module tuananhdohoang::swap_coin;
use sui::{
    coin::{Self, Coin, TreasuryCap},
    tx_context::TxContext,
    balance::{Self, Balance},
};
use tuananhdohoang::usdt::{Self, USDT};
use tuananhdohoang::anhdoo::{Self, ANHDOO};
public struct  Liquidity_Pool has key{
    id: UID,
    coin_a: Coin<USDT>,
    coin_b: Coin<ANHDOO>,
    fee: u64,
}
//pool inintialize
const EPool_NO_ENOUGH: u64 = 3;
public fun swap_coin_USDT_ANHDOO(pool: &mut Liquidity_Pool, amount: Coin<USDT> , ctx: &mut TxContext){
    let coin_a = &mut pool.coin_a;
    let coin_b = &mut pool.coin_b;
    
    let coin_a_value = coin::value(coin_a);
    let coin_amout_value = coin::value(&amount);

    let fee = pool.fee * coin_amout_value / 100;
    let mixup = coin::value(coin_a) * coin::value(coin_b);
    
    let mut coin_b_maintain = mixup/(coin_a_value + coin_amout_value - fee);
    let coin_b_return = coin::value(coin_b) - coin_b_maintain;
    assert!(coin_b_return <= coin::value(coin_b), EPool_NO_ENOUGH);
    let coin_b_return = coin::split(coin_b, coin_b_return, ctx);
    transfer::public_transfer(coin_b_return, ctx.sender());


    //put lượng amount vào a
    let mut balance_a: &mut Balance<USDT> = coin::balance_mut(coin_a);
    coin::put(balance_a,amount);
}
public fun swap_coin_ANHDOO_USDT(pool: &mut Liquidity_Pool, amount: Coin<ANHDOO> , ctx: &mut TxContext){
    let coin_a = &mut pool.coin_a;
    let coin_b = &mut pool.coin_b;
    
    let coin_b_value = coin::value(coin_b);
    let coin_amout_value = coin::value(&amount);

    let fee = pool.fee * coin_amout_value / 100;
    let mixup = coin::value(coin_a) * coin::value(coin_b);
    
    //lượng cần return phải <= lượng đang còn trong pool
    let mut coin_a_maintain = mixup/(coin_b_value + coin_amout_value - fee);
    let coin_a_return = coin::value(coin_a) - coin_a_maintain;
    assert!(coin_a_return <= coin::value(coin_a), EPool_NO_ENOUGH);
    
    let coin_a_return = coin::split(coin_a, coin_a_return, ctx);
    transfer::public_transfer(coin_a_return, ctx.sender());

    //put lượng amount vào a
    let mut balance_b: &mut Balance<ANHDOO> = coin::balance_mut(coin_b);
    coin::put(balance_b,amount);
}
fun mint_usdt(treasury: &mut TreasuryCap<USDT>,pool: &mut Liquidity_Pool,  ctx:&mut TxContext){
    let (c_pool, c_user): (Coin<USDT>,Coin<USDT>) = usdt::faucet(treasury, ctx);
    transfer::public_transfer(c_user, ctx.sender());
    
    let mut balance_a: &mut Balance<USDT> = coin::balance_mut(&mut pool.coin_a);
    coin::put(balance_a,c_pool);
}
fun mint_anhdoo(treasury: &mut TreasuryCap<ANHDOO>,pool: &mut Liquidity_Pool,  ctx:&mut TxContext){
    let (c_pool, c_user): (Coin<ANHDOO>,Coin<ANHDOO>) = anhdoo::faucet(treasury, ctx);
    transfer::public_transfer(c_user, ctx.sender());
    
    let mut balance_b: &mut Balance<ANHDOO> = coin::balance_mut(&mut pool.coin_b);
    coin::put(balance_b,c_pool);
}
public fun mint_coins(treasury1: &mut TreasuryCap<USDT>,treasury2: &mut TreasuryCap<ANHDOO>, pool: &mut Liquidity_Pool,  ctx:&mut TxContext){
    mint_usdt(treasury1, pool, ctx);
    mint_anhdoo(treasury2, pool, ctx);
}
fun init(ctx:&mut TxContext){
    let pool = Liquidity_Pool{
        id: object::new(ctx),
        coin_a: coin::zero(ctx),
        coin_b: coin::zero(ctx),
        fee: 30,
    };
    transfer::share_object(pool);
}
