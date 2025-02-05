
module my_coin::faucet_coin{

    use sui::coin::{Self, Coin, TreasuryCap};
   use sui::url::{Self, Url};

    public struct FAUCET_COIN has drop {}


    fun init (witness: FAUCET_COIN, ctx: &mut TxContext){
        let (treasury_cap, metadata) = coin::create_currency<FAUCET_COIN>(
            witness,
            5,
            b"KhoaDN",
            b"Khoa Coin",
            b"Coin siu cute",
           option::none(),
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint(treasury: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext ){
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }
}