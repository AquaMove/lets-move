/*
/// Module: my_coin
module my_coin::my_coin;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module 0x0::my_coin {
     
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    
     // OWT
     public struct MY_COIN has drop {}

     fun init(witness: MY_COIN, ctx: &mut TxContext){
         
        let(treasury, coinmetada) = coin::create_currency(
        witness, 
        5, 
        b"HUC", 
        b"HUC coin", 
        b"My first coin",
        option::none(),
        ctx);

        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);
     }

      public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext){
        let coin_object = coin::mint(treasury, 35000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}