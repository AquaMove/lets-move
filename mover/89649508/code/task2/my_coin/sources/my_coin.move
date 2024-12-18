module my_coin::my_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
		let (treasury, metadata) = coin::create_currency(
				witness,
				3,
				b"TAT2",
				b"TAT AI Memecoin",
				b"This coin is created in Sui Hackcamp 2024 by Tran Anh Tuan",
				option::some(url::new_unsafe_from_bytes(b"https://tokeninsight.com/cdn-cgi/image/width=780,height=520,format=webp,quality=100,fit=cover/https://s2.tokeninsight.com/static/news/cover/img/sd97v6a9.jpeg")),
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