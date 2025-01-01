/*
/// Module: my_coin
module my_coin::my_coin;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module my_coin::my_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    public struct MY_COIN has drop {}

    fun init(otw: MY_COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw, 
            6,
            b"LP",
            b"LongPhu Coin",
            b"My Coin is a coin that only specific addresses can mint.",
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/longphu25/lets-move/refs/heads/task2/mover/longphu25/images/my-coin.png")), 
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    public entry fun mint(tc: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(tc, amount, recipient, ctx);
    }


    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(MY_COIN{}, ctx);
    }
}
