/*
/// Module: phuclam_faucet_token
module phuclam_faucet_token::phuclam_faucet_token;
*/
module faucet_token::phuclam_faucet_token{
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use std::option::{Self, Option, some, none};
    use sui::url::{Self, Url};
    use std::ascii;
    use std::string;

    // Struct name should match the module name in uppercase
    public struct PHUCLAM_FAUCET_TOKEN has drop {}

    fun init(otw: PHUCLAM_FAUCET_TOKEN, ctx: &mut TxContext) {
        let (treasuryCap, coinMetadata) = coin::create_currency(
            otw, // witness
            6, // decimals
            b"PHUCLAM", // symbol
            b"Phuclam Faucet", // name
            b"Phuclam token for testing faucet, because he's chill guy", // description
            some(url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/JSxwDwYWwmZs9AG-UaenzJOBodr0mCwXOI_Ik9XOTXw")), // icon url
            ctx, // ctx
        );
        transfer::public_transfer(treasuryCap, sender(ctx));
        transfer::public_share_object(coinMetadata);
    }

    public entry fun mint<T>(
        cap: &mut TreasuryCap<T>, 
        value: u64,
        receiver: address,
        ctx: &mut TxContext
    ) {
        let mint_coin = coin::mint<T>(
            cap,
            value,
            ctx,
        );
        transfer::public_transfer(mint_coin, receiver);
    }

    public entry fun burn<T>(
        cap: &mut TreasuryCap<T>, 
        input_coin: Coin<T>
    ) {
        coin::burn<T>(cap, input_coin);
    }}
