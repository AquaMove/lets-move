/*
/// Module: my_coin
module my_coin::my_coin;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module my_coin::my_coin {

    use sui::coin::{Self, TreasuryCap};

    // OTW
    public struct MY_COIN has drop {}


    
    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(witness, 
     6, 
     b"LAMDANGHOANG", 
     b"Hoang Lam Coin", 
     b"Hoang Lam's first coin", 
     option::none(), 
     ctx);

     transfer::public_freeze_object(coinmetadata);
     transfer::public_transfer(treasury, ctx.sender());
    }

    public fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 500000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}
