module faucet_coin::faucet_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct FAUCET_COIN has drop {}

fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
	let (treasury, metadata) = coin::create_currency(
			witness,
			4,
			b"TuanO20 Faucet",
			b"TuanO20 Faucet coin",
			b"This coin is created in Sui Hackcamp 2024 by Tran Anh Tuan",
			option::some(url::new_unsafe_from_bytes(b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuS8uLzu8811CR9e1QlaQ6IgPv2x234fqG4A&s")),
			ctx,
	);
	transfer::public_freeze_object(metadata);
	//transfer::public_transfer(treasury, ctx.sender());
	transfer::public_share_object(treasury);
}

public entry fun mint(
		treasury_cap: &mut TreasuryCap<FAUCET_COIN>,
		ctx: &mut TxContext,
) {
		let coin = coin::mint(treasury_cap, 10000, ctx);
		transfer::public_transfer(coin, ctx.sender())
}