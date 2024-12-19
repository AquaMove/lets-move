module my_coin::my_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
		let (treasury, metadata) = coin::create_currency(
				witness,
				3, 
				b"TuanO20",
				b"TuanO20 coin",
				b"This coin is created in Sui Hackcamp 2024 by Tran Anh Tuan",
				option::some(url::new_unsafe_from_bytes(b"https://pbs.twimg.com/profile_images/1852729160579354624/wKKkFU5A_400x400.jpg")),
				ctx,
		);
		transfer::public_freeze_object(metadata);
		transfer::public_transfer(treasury, ctx.sender())
}

public fun mint(
		treasury_cap: &mut TreasuryCap<MY_COIN>,
		amount: u64,
		recipient: address,
		ctx: &mut TxContext,
) {
		let coin = coin::mint(treasury_cap, amount, ctx);
		transfer::public_transfer(coin, recipient)
}