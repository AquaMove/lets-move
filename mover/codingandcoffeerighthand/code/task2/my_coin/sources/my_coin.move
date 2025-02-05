module my_coin::my_coin;

use sui::coin::{Self,TreasuryCap};

public struct MY_COIN has drop {}

fun init(otw: MY_COIN, ctx: &mut TxContext) {
    let (treasury, coinmetadata) = coin::create_currency(
        otw,
        6,
        b"MYCOIN",
        b"My Coin",
        b"codingandcoffeerighthand Coin",
        option::none(),
        ctx,
    );
    transfer::public_freeze_object(coinmetadata);
    transfer::public_transfer(treasury, ctx.sender());
}

public entry fun mint_token(
    treasury: &mut TreasuryCap<MY_COIN>,
    ctx: &mut TxContext,
){
    let coin_obj = coin::mint(treasury,10_000_000, ctx);
    transfer::public_transfer(coin_obj, ctx.sender());
}