/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
*/

module 0x0::faucet_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    // One time witness
    public struct FAUCET_COIN has drop {}

    
    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury_cap, coin_metadata) = coin::create_currency(
            witness,
            5,
            b"FC",
            b"faucet coin",
            b"My faucet coin",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(coin_metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint_token(treasury_cap: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
        let coin_obj = coin::mint(treasury_cap, 100000, ctx);
        transfer::public_transfer(coin_obj, ctx.sender());
    }
}