module my_coin::my_coin;
use sui::coin::{Self, TreasuryCap};
use std::u64;

const DECIMALS: u8 = 8;
public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
    let (treasury, coin_meta) = coin::create_currency(
        witness, DECIMALS, b"ZRC", b"Zircon", b"An's Coin", option::none(), ctx);

    transfer::public_transfer(coin_meta, ctx.sender());
    transfer::public_transfer(treasury, ctx.sender());
}

entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
    let value = 1 * u64::pow(10, DECIMALS);
    let coin_object = coin::mint(treasury, value, ctx);
    transfer::public_transfer(coin_object, ctx.sender());
}
