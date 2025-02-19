/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
Author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module faucet_coin::faucet_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct FAUCET_COIN has drop {}

fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
    let (treasury, coinmeta) = coin::create_currency(
        witness,
        5,
        b"nhoc20170861",
        b"nhoc20170861 facucet coin",
        b"FAUCET_COIN made by nhoc20170861",
        option::some(url::new_unsafe_from_bytes(b"https://cdn3d.iconscout.com/3d/premium/thumb/sui-coin-3d-icon-download-in-png-blend-fbx-gltf-file-formats--crypto-cryptocurrency-pack-science-technology-icons-7479564.png")),
        ctx,
    );

    transfer::public_freeze_object(coinmeta);
    transfer::public_share_object(treasury);
}

public entry fun mint_token(treasury_cap: &mut TreasuryCap<FAUCET_COIN>,  amount: u64, recipient: address,ctx: &mut TxContext) {
     coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
}

#[test_only]
public fun init_for_testing(ctx: &mut TxContext) {
    init(FAUCET_COIN{}, ctx);
}
