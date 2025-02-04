/*
/// Module: my_coin
module my_coin::my_coin;
*/


module 0x0::my_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    //OTW
    public struct MY_COIN has drop{}

    fun init(witness: MY_COIN, ctx: &mut TxContext){

        let(treasury, coinmetada) = coin::create_currency<MY_COIN>(
        witness, 
        5, 
        b"KHOADN", 
        b"Khoa coin", 
        b"My first coin",
        option::none(),
        ctx);

        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);

    }

    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>,amount: u64, recipient: address,  ctx: &mut TxContext){
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }


}