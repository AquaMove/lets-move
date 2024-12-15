module faucet_coin::faucet_coin;
use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct FAUCET_COIN has drop {}

public struct TreasuryCapKeeper has key, store {
  id: UID,
  cap: TreasuryCap<FAUCET_COIN>
}

fun init(otw: FAUCET_COIN,ctx: &mut TxContext){
  let (treasury_cap, metadata) = coin::create_currency(
    otw, 
    6, 
    b"FCC", 
    b"codingandcoffeerighthand Faucet Coin", 
    b"This Faucet coin is coin that anyone can mint.",
    option::some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/105044388")),
    ctx
  );
  transfer::public_freeze_object(metadata);
  transfer::public_share_object(TreasuryCapKeeper { 
    id: object::new(ctx), 
    cap : treasury_cap
  });
}

public entry fun mint(keeper: &mut TreasuryCapKeeper, amount: u64, recipient: address, ctx: &mut TxContext) {
    coin::mint_and_transfer(&mut keeper.cap, amount, recipient, ctx);
}

public fun get_cap(keeper: &TreasuryCapKeeper): &TreasuryCap<FAUCET_COIN> {
    &keeper.cap
}