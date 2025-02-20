module 0x0::faucet_coin {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<FAUCET_COIN>(
            witness, 
            2, 
            b"y_v's faucet coin", 
            b"y_v's faucet coin", 
            b"y_v's faucet coin", 
            option::none(), 
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);

    }

    public entry fun mint(treasury_cap: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        // let coin_object = coin::mint(treasury, 35000, ctx);
        // transfer::public_transfer(coin_object, ctx.sender());
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
    }

    public fun burn(treasury_cap: &mut TreasuryCap<FAUCET_COIN>, coin: Coin<FAUCET_COIN>) {
        coin::burn(treasury_cap, coin);

    }

}
