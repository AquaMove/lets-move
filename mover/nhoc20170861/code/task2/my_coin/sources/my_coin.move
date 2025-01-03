/*
/// Module: my_coin
module my_coin::my_coin;
Author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module my_coin::my_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
    let (treasury, coinmeta) = coin::create_currency(
        witness,
        5,
        b"nhoc20170861",
        b"nhoc20170861 coin",
        b"First coin made by nhoc20170861",
        option::some(url::new_unsafe_from_bytes(b"https://png.pngtree.com/png-clipart/20211008/ourmid/pngtree-gold-dollar-coin-png-image_3975554.png")),
        ctx,
    );

    transfer::public_freeze_object(coinmeta);
    transfer::public_transfer(treasury, ctx.sender());
}

public entry fun mint_token(treasury_cap: &mut TreasuryCap<MY_COIN>,  amount: u64, recipient: address,ctx: &mut TxContext) {
     coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
}

#[test_only]
public fun init_for_testing(ctx: &mut TxContext) {
    init(MY_COIN{}, ctx);
}
