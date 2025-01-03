/*
/// Module: my_coin
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module my_coin::my_coin;
use sui::coin::{Self, TreasuryCap};
use sui::tx_context::TxContext;
use std::option;
use sui::url::{Self, Url};
use sui::transfer;
public struct MY_COIN has drop{}
fun init(witness: MY_COIN, ctx:&mut TxContext){
    let decimals = 6;
    let name = b"";
    let description = b"";
    let symbol = b"ANHDOO";
    let icon_url = option::none();

    let (treasury, metadata) = coin::create_currency(witness, decimals, symbol, name, description, icon_url, ctx);
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury,ctx.sender());
}

public fun mint(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext){
    let mint_coin = coin::mint(treasury, 1000000, ctx);
    transfer::public_transfer(mint_coin, ctx.sender());
}