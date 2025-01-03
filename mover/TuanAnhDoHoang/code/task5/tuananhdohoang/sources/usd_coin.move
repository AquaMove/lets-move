module tuananhdohoang::usdt;

use sui::tx_context::TxContext;
use sui::coin::{Self, TreasuryCap, CoinMetadata, Coin};
use std::option;

public struct USDT has drop {}

public fun create(witness: USDT, ctx: &mut TxContext): TreasuryCap<USDT>{
    let (mut treasury,coinmetadata) = coin::create_currency(witness,6,b"USDT",b"USDT",b"USDT", option::none(), ctx);
    transfer::public_freeze_object(coinmetadata);
    treasury
}
public fun mint(treasury: &mut TreasuryCap<USDT>, amount: u64, ctx: &mut TxContext): Coin<USDT>{
    let c_mint = coin::mint(treasury, amount, ctx);
    c_mint
}
public fun faucet(treasury: &mut TreasuryCap<USDT>, ctx: &mut TxContext): (Coin<USDT>, Coin<USDT>){
    let c_mint1 = mint(treasury, 1000000, ctx);
    let c_mint2 = mint(treasury, 50000, ctx);
    (c_mint1, c_mint2)
}
fun init(witness: USDT, ctx: &mut TxContext){
    let (mut treasury,coinmetadata) = coin::create_currency(witness,6,b"USDT",b"USDT",b"USDT", option::none(), ctx);
    transfer::public_freeze_object(coinmetadata);
    transfer::public_share_object(treasury);
}