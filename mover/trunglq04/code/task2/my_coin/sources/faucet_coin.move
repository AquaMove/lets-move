module 0x0::trunglq04_faucet_coin {

    use sui::coin::{Self, TreasuryCap, Coin};


    public struct TRUNGLQ04_FAUCET_COIN has drop {}

    fun init(witness: TRUNGLQ04_FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            2,
            b"TRUNGLQ04 COIN", 
            b"TRUNGLQ04 GAME FAUCET",
            b"TRUNGLQ04 Game On BlockChain",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint(treasury: &mut TreasuryCap<TRUNGLQ04_FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) 
    {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }

    public fun burn(treasury: &mut TreasuryCap<TRUNGLQ04_FAUCET_COIN>, coin: Coin<TRUNGLQ04_FAUCET_COIN>) {
        coin::burn(treasury, coin);
    }
}