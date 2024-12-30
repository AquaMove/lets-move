module faucet_coin::faucet_coin {
    use sui::coin::{Self, TreasuryCap};

    // OTW
    public struct FAUCET_COIN has drop {}


    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasuryCap, coinMetaData) = coin::create_currency(witness, 5,  b"thinhtv_faucet_coin", b"my faucet coin",  b"My first faucet coin", option::none(), ctx);

        transfer::public_freeze_object(coinMetaData);
        transfer::public_share_object(treasuryCap)
    }

    public fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 350000, ctx);

        transfer::public_transfer(coin_object, ctx.sender())
    }
}
