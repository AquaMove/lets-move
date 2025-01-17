module faucet_token::faucet_token {
    use sui::coin::{Self, create_currency, TreasuryCap};
    use sui::url::{Self};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use std::option::{Self, some};
    

    // Define the one-time witness struct
    public struct FAUCET_TOKEN has drop {}
    
    fun init(witness: FAUCET_TOKEN, ctx: &mut TxContext) {
        let (treasury, metadata) = create_currency(
            witness, 
            8, 
            b"FAUCET_TOKEN", 
            b"PhucLam Coin", 
            b"This is PhucLam's test coin on Sui",
            some(url::new_unsafe_from_bytes(b"https://drive.google.com/file/d/11dgb-60066S4IIKgI5tDR4RKueZ-5vWZ/view?usp=sharing")), // icon url

            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint(
        treasury: &mut TreasuryCap<FAUCET_TOKEN>,
        ctx: &mut TxContext
    ) {
        let mint_coin = coin::mint(treasury, 1000000000000000000, ctx);
        transfer::public_transfer(mint_coin, ctx.sender());
    }
} 
