module move_coin::minhnd410;

use sui::coin::{Self, TreasuryCap};
use sui::url::{new_unsafe};

public struct MINHND410 has drop {}

fun init(witness: MINHND410, ctx: &mut TxContext) {
    let token_url = new_unsafe(std::ascii::string(b"https://strapi-dev.scand.app/uploads/sui_c07df05f00.png"));
    let (treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"MINHND410",
        b"minhnd410 coin",
        b"task 2 - coin",
        option::some(token_url),
        ctx,
    );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender())
}

public fun mint(
    treasury_cap: &mut TreasuryCap<MINHND410>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient)
}