
module 0x0::quang_coin {

    use std::option;
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct QUANG_COIN has drop {}

    fun init(witness: QUANG_COIN, ctx: &mut TxContext) {
        let (treasury, coinmedata) = coin::create_currency(
            witness,
            5,
            b"QuangITcoder", 
            b"QUANG COIN",
            b"My first coin",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(coinmedata);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint_token(
        treasury: &mut TreasuryCap<QUANG_COIN>, ctx: &mut TxContext,
    ) {
        let coin_object = coin::mint(treasury, 35000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}

