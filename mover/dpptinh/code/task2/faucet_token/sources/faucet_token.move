module faucet_token::faucetmycoin{  
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
            b"PT",
            b"PT Coin",
            b"you can hold PT coins! hihi?",
            option::some(url::new_unsafe_from_bytes(b"https://www.facebook.com/photo.php?fbid=1422307388703123&set=pb.100027716251335.-2207520000&type=3")),
            ctx,
        );
        transfer::public_transfer(treasuryCap, sender(ctx));
        transfer::public_share_object(coinMetadata);
    }

    /// create coin and update total supply
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