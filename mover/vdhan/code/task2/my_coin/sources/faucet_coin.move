module 0x0::faucet_coin;
use sui::coin::{Self, TreasuryCap};
use std::u64;

public struct FAUCET_COIN has drop {}
const DECIMALS: u8 = 9;

fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
    let (treasury, coin_meta) = coin::create_currency(
        witness, DECIMALS, b"COR", b"Coral", b"An's Coin", option::none(), ctx);

    transfer::public_freeze_object(coin_meta);
    transfer::public_share_object(treasury);
}

public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
    let value = 1 * u64::pow(10, DECIMALS);
    let coin_object = coin::mint(treasury, value, ctx);
    transfer::public_transfer(coin_object, ctx.sender());
}
