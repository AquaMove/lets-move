module 0x0::my_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetada) = coin::create_currency<MY_COIN>(
            witness,
            5,
            b"NTINS",
            b"VNTC",
            b"My first coin",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 350000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}
