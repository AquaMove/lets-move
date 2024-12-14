module token::token {
    use sui::coin::{Self, create_currency, TreasuryCap};
    use sui::url::{Self};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use std::option::{Self, some};

    // Define the one-time witness struct
    public struct TOKEN has drop {}
    
    fun init(witness: TOKEN, ctx: &mut TxContext) {
        let (treasury, metadata) = create_currency(
            witness, 
            8, 
            b"PHUCLAM", 
            b"PhucLam Coin", 
            b"This is PhucLam's test coin on Sui", 
            some(url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/JSxwDwYWwmZs9AG-UaenzJOBodr0mCwXOI_Ik9XOTXw")), 
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, sender(ctx));
    }

    public entry fun mint(
        treasury: &mut TreasuryCap<TOKEN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }
}
