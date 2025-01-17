module 0x0::my_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coin_metadata) = coin::create_currency(witness, 5, b"HIGHCOIN", b"High Coin", b"my super coin", option::none(), ctx);

        transfer::public_freeze_object(coin_metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 1000000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}
