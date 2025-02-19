
module khoa_dam::faucet_coin {

    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::url::{Self, Url};

   use std::option;

    public struct FAUCET_COIN has drop {}


    fun init (witness: FAUCET_COIN, ctx: &mut TxContext){
        let (treasury_cap, metadata) = coin::create_currency<FAUCET_COIN>(
            witness,
            5,
            b"KhoaDN",
            b"Khoa Coin",
            b"Coin siu cute",
           option::some(url::new_unsafe_from_bytes(b"https://i.pinimg.com/736x/21/1e/3b/211e3b2a0ccc6d7edb7f7b14289d3735.jpg")),
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint(treasury: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext ){
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }
}