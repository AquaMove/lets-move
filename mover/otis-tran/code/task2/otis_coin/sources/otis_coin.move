module otis_coin::otis_coin;

use sui::coin::{Self, TreasuryCap};

// One Time Witness (uppercase of module name)
public struct OTIS_COIN has drop {}

// Module initializer is called once on module publish. 
// A treasury cap is sent to the publisher, who then controls minting and burning.
fun init(witness: OTIS_COIN, ctx: &mut TxContext) {
    let (treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"OTIS",
        b"Otis coin",
        b"Otis's first coin",
        option::none(),
        ctx,
    );
    // Freezing this object makes the metadata immutable, including the title, name, and icon image.
    // If want to allow mutability, share it with public_share_object instead.
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender())
}

// Create OTIS_COINs using the TreasuryCap.
public entry fun mint(
    treasury_cap: &mut TreasuryCap<OTIS_COIN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient)
}
