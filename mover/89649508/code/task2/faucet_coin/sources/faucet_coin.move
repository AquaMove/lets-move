module faucet_coin::faucet_coin;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct FAUCET_COIN has drop {}

fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
		let (treasury, metadata) = coin::create_currency(
				witness,
				4,
				b"TAT_FaucetCoin",
				b"TAT Meme Faucet",
				b"This coin is created in Sui Hackcamp 2024 by Tran Anh Tuan",
				option::some(url::new_unsafe_from_bytes(b"https://cdn3d.iconscout.com/3d/premium/thumb/coin-faucet-3d-icon-download-in-png-blend-fbx-gltf-file-formats--bitcoin-logo-flow-cryptocurrency-vol-1-pack-science-technology-icons-5376680.png")),
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