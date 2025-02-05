module tuananhdohoang::anhdoo;
use sui::tx_context::TxContext;
use sui::coin::{Self, TreasuryCap, CoinMetadata, Coin};
use std::option;

public struct ANHDOO has drop{}
public fun create(witness: ANHDOO, ctx: &mut TxContext): TreasuryCap<ANHDOO>{
    let (mut treasury,coinmetadata) = coin::create_currency(witness,6,b"ANHDOO",b"ANHDOO",b"ANHDOO", option::none(), ctx);
    transfer::public_freeze_object(coinmetadata);
    treasury
}
public fun mint(treasury: &mut TreasuryCap<ANHDOO>, amount: u64, ctx: &mut TxContext): Coin<ANHDOO>{
    let c_mint = coin::mint(treasury, amount, ctx);
    c_mint
}
public fun faucet(treasury: &mut TreasuryCap<ANHDOO>, ctx: &mut TxContext): (Coin<ANHDOO>, Coin<ANHDOO>){
    let c_mint1 = mint(treasury, 1000000, ctx);
    let c_mint2 = mint(treasury, 50000, ctx);
    (c_mint1, c_mint2)
}
fun init(witness: ANHDOO, ctx: &mut TxContext){
    let (mut treasury,coinmetadata) = coin::create_currency(witness,6,b"ANHDOO",b"ANHDOO",b"ANHDOO", option::none(), ctx);
    transfer::public_freeze_object(coinmetadata);
    transfer::public_share_object(treasury);
}