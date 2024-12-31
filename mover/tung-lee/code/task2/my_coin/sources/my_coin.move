/*
/// Module: my_coin
module my_coin::my_coin;
*/

module 0x0::my_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    // One time witness
    public struct MY_COIN has drop {}

    
    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury_cap, coin_metadata) = coin::create_currency(
            witness,
            5,
            b"TL",
            b"tung-lee coin",
            b"My fungible token",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(coin_metadata);
        transfer::public_transfer(treasury_cap, ctx.sender());
    }

    public fun mint_token(treasury_cap: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_obj = coin::mint(treasury_cap, 100000, ctx);
        transfer::public_transfer(coin_obj, ctx.sender());
    }
}