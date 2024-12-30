module my_coin::my_coin {
    use sui::coin::{Self, TreasuryCap};

    // OTW
    public struct MY_COIN has drop {}

    
    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasuryCap, coinMetaData) = coin::create_currency(witness, 5,  b"thinhtv_my_coin", b"my coin",  b"My first coin", option::none(), ctx);

        transfer::public_freeze_object(coinMetaData);
        transfer::public_transfer(treasuryCap, ctx.sender())
    }

    public fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 350000, ctx);

        transfer::public_transfer(coin_object, ctx.sender())
    }
}
