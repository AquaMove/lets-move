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
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, sender(ctx));
    }

    public fun mint(
        treasury: &mut TreasuryCap<TOKEN>,
        ctx: &mut TxContext
    ) {
        let mint_coin = coin::mint(treasury, 1000000000000000000, ctx);
        transfer::public_transfer(mint_coin, sender(ctx));
    }
}