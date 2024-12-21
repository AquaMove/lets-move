module move_faucet_coin::minhnd410_Faucet;

use sui::coin::{Self, TreasuryCap};
use sui::url::{new_unsafe};

public struct MINHND410_FAUCET has drop {}

fun init(witness: MINHND410_FAUCET, ctx: &mut TxContext) {
    let token_url = new_unsafe(std::ascii::string(b"https://strapi-dev.scand.app/uploads/sui_c07df05f00.png"));
    let (treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"MINHND410_FAUCET",
        b"minhnd410 faucet coin",
        b"task 2 - faucet coin",
        option::some(token_url),
        ctx,
    );
    transfer::public_freeze_object(metadata);
    transfer::public_share_object(treasury)
}

public fun mint(
    treasury_cap: &mut TreasuryCap<MINHND410_FAUCET>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient)
}