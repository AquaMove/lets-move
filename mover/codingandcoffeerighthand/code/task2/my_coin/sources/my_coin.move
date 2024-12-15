module my_coin::my_coin;
use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
    let (treasury_cap, metadata) = coin::create_currency(
        witness,
        6,
        b"MYCOIN", 
        b"codingandcoffeerighthand Coin",
        b"Only codingandcoffeerighthand can min.",
        option::some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/105044388")),
        ctx
    );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
}
public entry fun mint(c: &mut TreasuryCap<MY_COIN>,  amount: u64, recipient: address, ctx: &mut TxContext) {
  coin::mint_and_transfer(c, amount, recipient, ctx)
}