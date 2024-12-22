/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
*/
module faucet_coin::knave {
use sui::coin::{Self, TreasuryCap};
public struct KNAVE has drop {}

fun init(witness: KNAVE, ctx: &mut TxContext) {
    let (treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"KCC",
        b"KnaveCrypto Coin",
        b"Ai cung~ mint coin nay` duoc het",
        option::none(),
        ctx,
    );
    transfer::public_freeze_object(metadata);
	transfer::public_share_object(treasury)
}
public fun mint(
		treasury_cap: &mut TreasuryCap<KNAVE>,
		amount: u64,
		recipient: address,
		ctx: &mut TxContext,
) {
		let coin = coin::mint(treasury_cap, amount, ctx);
		transfer::public_transfer(coin, recipient)
}
}