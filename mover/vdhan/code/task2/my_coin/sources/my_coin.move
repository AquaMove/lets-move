module 0x0::my_coin;
use sui::coin::{Self, TreasuryCap};

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
    let (treasury, coin_meta) = coin::create_currency(
        witness, 9, b"COR", b"Coral", b"An's Coin", option::none(), ctx);

    transfer::public_freeze_object(coin_meta);
    transfer::public_transfer(treasury, ctx.sender());
}

public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury, 1_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender());
}
