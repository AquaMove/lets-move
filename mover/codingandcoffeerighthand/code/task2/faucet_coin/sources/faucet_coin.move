module faucet_coin::faucet_coin;

use sui::coin::{Self,TreasuryCap};

public struct FAUCET_COIN has drop {}

fun init(otw: FAUCET_COIN, ctx: &mut TxContext) {
    let (treasury, coinmetadata) = coin::create_currency(
        otw,
        6,
        b"FAUCETCOIN",
        b"Faucet Coin",
        b"codingandcoffeerighthand Faucet Coin",
        option::none(),
        ctx,
    );
    transfer::public_freeze_object(coinmetadata);
    transfer::public_share_object(treasury);
}

public entry fun mint_token(
    treasury: &mut TreasuryCap<FAUCET_COIN>,
    ctx: &mut TxContext,
){
    let coin_obj = coin::mint(treasury,10_000_000, ctx);
    transfer::public_transfer(coin_obj, ctx.sender());
}