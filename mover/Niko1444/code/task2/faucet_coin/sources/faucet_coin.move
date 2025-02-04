/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
*/

module 0x0::faucet_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    // One Time Witness
    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
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
        transfer::public_share_object(treasury);
}

    public entry fun mint_coin(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
    let coin_object = coin::mint(treasury, 1_000_000_000, ctx);
    transfer::public_transfer(coin_object, ctx.sender());
}
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


