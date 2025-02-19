module 0x0::faucetmycoin{  
    use sui::tx_context::{sender};
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::url::{Self};

    // === define struct
    public struct FAUCETMYCOIN has drop{}

    #[allow(lint(share_owned))]
    fun init (witness: FAUCETMYCOIN, ctx: &mut TxContext){
        let (treasuryCap, coinMetadata) = coin::create_currency(
            witness,
            8,
            b"PHUQUIIVO03",
            b"Phuquiivo03 Coin",
            b"ayyo phuquivo03 toichoi!",
            option::some(url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/X7KET_iwogbmrgD7ITJE-ZUE6k01TrK8d8AtV4l2FfI")),
            ctx
        );
        transfer::public_share_object(treasuryCap);
        transfer::public_share_object(coinMetadata);
    }

    /// create coin and update total supply
    public entry fun mint(
        cap: &mut TreasuryCap<FAUCETMYCOIN>, 
        value: u64,
        receiver: address,
        ctx: &mut TxContext){
        let mint_coin = coin::mint(
            cap,
            value,
            ctx,
        );
        transfer::public_transfer(mint_coin, receiver);
    }


}