

module 0x0::my_coin {

    use std::option::{Self, some};
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::url::{Self};

    public struct MY_COIN has drop {}

   fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmedata) = coin::create_currency(
            witness,
            5,
            b"Brian-q", 
            b"BRIANQUANGDEV",
            b"My first coin",
            some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/194399046?v=4")),
            ctx
        );
        transfer::public_freeze_object(coinmedata);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }
}