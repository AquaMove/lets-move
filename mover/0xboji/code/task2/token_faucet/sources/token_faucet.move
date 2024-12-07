module task2::boji_coin_faucet{  
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use sui::coin::{Self, Coin, TreasuryCap, CoinMetadata};
    use std::option::{none};
    use std::ascii;
    use std::string;
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Structs <<<<<<<<<<
    public struct BOJI_COIN_FAUCET has drop{}
    // >>>>>>>>>> End Structs <<<<<<<<<<

    #[allow(lint(share_owned))]
    fun init (otw: BOJI_COIN_FAUCET, ctx: &mut TxContext){
        let (treasuryCap, coinMetadata) = coin::create_currency(
            otw, // witness
            6, // decimals
            b"BOJI_COIN_FAUCET", // symbol
            b"Boji Coin Faucet", // name
            b"Boji Coin Faucet", // description
            none(), // icon url
            ctx, // ctx
            );
        transfer::public_transfer(treasuryCap, sender(ctx));
        transfer::public_share_object(coinMetadata);
    }

    public entry fun mint<T>(
        cap: &mut TreasuryCap<T>, 
        value: u64,
        receiver: address,
        ctx: &mut TxContext){
        let mint_coin = coin::mint<T>(
            cap,
            value,
            ctx,
        );
        transfer::public_transfer(mint_coin, receiver);
    }

    public entry fun burn<T>(
        cap: &mut TreasuryCap<T>, 
        input_coin: Coin<T>,){
        coin::burn<T>(cap, input_coin);
    }
}