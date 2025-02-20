module 0x0::my_coin {
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::{Self, TxContext};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmeta) = coin::create_currency(
            witness,
            5,
            b"shogun",
            b"shogun coin",
            b"First coin",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(coinmeta);
        transfer::public_share_object(treasury);

    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }

    public fun burn(treasury: &mut TreasuryCap<MY_COIN>, coin: Coin<MY_COIN>) {
        coin::burn(treasury, coin);
    }
}