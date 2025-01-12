/*
/// Module: my_coin
module my_coin::my_coin;
*/

module 0x0::my_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;
    // One Time Witness
    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness, 
            5, 
            b"Niko1444", 
            b"Niko1444 Coin", 
            b"My first coin on Sui!", 
            option::some(url::new_unsafe_from_bytes(b"https://i.ibb.co/s53RZQP/Flatten-Logo.png")), 
            ctx
        );

        transfer::public_freeze_object(coinmetadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }

    public fun mint_coin(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext){
        let coin_object = coin::mint(treasury, 100000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
    
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


