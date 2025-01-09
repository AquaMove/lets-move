module 0x0::faucet_coin {

    use std::option::{Self, some};
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::transfer;  
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self};

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

    public entry fun mint(treasury: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) 
    {
        // let coin_object = coin::mint(treasury, amount, ctx);
        // transfer::public_transfer(coin_object, recipient);
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }

    public fun burn(treasury: &mut TreasuryCap<FAUCET_COIN>, coin: Coin<FAUCET_COIN>) {
        coin::burn(treasury, coin);
    }
}