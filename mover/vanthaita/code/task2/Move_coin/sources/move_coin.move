module move_coin::my_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};


    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmedata) = coin::create_currency(
            witness,
            9,
            b"VAMTHAITA", 
            b"VANTHAITA COIN",
            b"My first coin",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(coinmedata);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint_and_transfer(treasury: &mut TreasuryCap<MY_COIN> ,ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, 1000000000 , ctx.sender(), ctx);
    }
}