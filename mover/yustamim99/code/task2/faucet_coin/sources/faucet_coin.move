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
            b"yustamim99", 
            b"YUSTAMIM99 FAUCET",
            b"DAY LA COIN FAUCET CUA YUSTAMIM99",
            some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/198051201?v=4")),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint(treasury: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) 
    {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }

    public fun burn(treasury: &mut TreasuryCap<FAUCET_COIN>, coin: Coin<FAUCET_COIN>) {
        coin::burn(treasury, coin);
    }
}

