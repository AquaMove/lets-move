/*
/// Module: faucet_coin
*/
module faucet_coin::faucet_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use std::option;
    use sui::transfer;
    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, coinmedata) = coin::create_currency(
            witness,
            9,
            b"VAMTHAITA FAUCET", 
            b"VANTHAITA FAUCET COIN",
            b"My first coin",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(coinmedata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_and_transfer(treasury: &mut TreasuryCap<FAUCET_COIN> ,ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, 100000000 , ctx.sender(), ctx);
    }
}
