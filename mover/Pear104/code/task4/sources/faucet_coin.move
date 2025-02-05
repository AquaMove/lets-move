module 0x0::faucet_coin {

    use std::option::{Self, some};
    use sui::coin::{Self, TreasuryCap};
    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url::{Self};

    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            5,
            b"PEAR_COIN",
            b"Pear Coin Faucet",
            b"My first coin",
            some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/107944687?v=4")),
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 100000000000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }

}