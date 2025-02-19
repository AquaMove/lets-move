
module task5::my_coin {

    use sui::coin::{Self,TreasuryCap};

    public struct MY_COIN has drop {}


    fun init (witness: MY_COIN, ctx: &mut TxContext){
        let (treasury_cap, metadata) = coin::create_currency<MY_COIN>(
            witness,
            5,
            b"HUC",
            b"HUC Coin",
            b"Fuck Coin is king",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext ){
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }
}