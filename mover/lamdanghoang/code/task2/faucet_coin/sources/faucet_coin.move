/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module faucet_coin::faucet_coin {

    use sui::coin::{Self, TreasuryCap};

    // OTW
    public struct FAUCET_COIN has drop {}


    
    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(witness, 
     6, 
     b"LAMDANGHOANG", 
     b"Hoang Lam Faucet Coin", 
     b"Hoang Lam's faucet coin", 
     option::none(), 
     ctx);

     transfer::public_freeze_object(coinmetadata);
     transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 500000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}