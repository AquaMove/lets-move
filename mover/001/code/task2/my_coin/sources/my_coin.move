module 0x0::my_coin {
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::TxContext;

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness,
            5,  // decimals
            b"AQ",  // symbol
            b"AnhQuan2004 Coin",  // name
            b"AnhQuan2004 Coin",  // description
            std::option::none(),  // icon URL
            ctx
        );

        transfer::public_freeze_object(coinmetadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx));
    }

    public fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
    let coin_object: Coin<MY_COIN> = coin::mint(treasury, 350000, ctx);
    
    transfer::public_transfer(coin_object, ctx.sender());
}

}

