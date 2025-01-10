module token::token{
  use sui::coin::{Self, Coin, TreasuryCap};
  use sui::url::{Self};

  // == Define Struct ==
  public struct TOKEN has drop {}

  fun init(witness: TOKEN, ctx: &mut TxContext){
    let (treasury_cap, metadata) = coin::create_currency(
      witness,
      8,
      b"PT",
      b"PT Coin",
      b"you can hold PT coins! hihi?",
      option::some(url::new_unsafe_from_bytes(b"https://www.facebook.com/photo.php?fbid=1422307388703123&set=pb.100027716251335.-2207520000&type=3")),
      ctx
    );

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
  }

  /// == Manager can mint Coin ==
  public entry fun mint(
        treasury: &mut TreasuryCap<TOKEN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
  }

  /// == Manager can burn Coin ==
  public fun burn(
        treasury: &mut TreasuryCap<TOKEN>,
        coin: Coin<TOKEN>,
    ) {
        coin::burn(treasury, coin);
  }

  /// == Test ==
  #[test_only]
  public fun test_init(ctx: &mut TxContext) {
    init(TOKEN {}, ctx)
  }
}