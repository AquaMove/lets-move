module 0x0::my_coin {

    use std::option::{Self, some};
    use sui::coin::{Self, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness,
            5,
            b"PEAR_COIN",
            b"Pear Coin",
            b"My first coin",
            some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/107944687?v=4")),
            ctx
        );

        transfer::public_freeze_object(coinmetadata);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 10000000000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }

}