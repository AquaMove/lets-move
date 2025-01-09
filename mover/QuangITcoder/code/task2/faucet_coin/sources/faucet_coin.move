

module faucet_coin::faucet_coin {

    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::url::{Self};
    use std::option::{Self, some};

    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            2,
            b"QF", 
            b"QUANGF COIN",
            b"DAY LA COIN FAUCET CUA QUANG",
            some(url::new_unsafe_from_bytes(b"https://lh3.googleusercontent.com/a/ACg8ocL90Vv1IXJMmMMO-HdAfAd7Xu9upsIOGqPcWKX_i42jAkJcmHRywA=s192-c-rg-br100")),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }


    public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) 
    {
        let coin_object = coin::mint(treasury, 35000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }

    // public fun burn(
    //     treasury: &mut TreasuryCap<FAUCET_COIN>, coin: Coin<FAUCET_COIN>,
    // ) {
    //     coin::burn(treasury, coin);
    // }
}

