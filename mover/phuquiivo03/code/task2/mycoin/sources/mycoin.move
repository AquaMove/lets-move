module my_coin::mycoin{
  use sui::coin::{Self, Coin, TreasuryCap};
  use sui::url::{Self};

  // == Define Struct ==
  public struct MYCOIN has drop {}

  fun init(witness: MYCOIN, ctx: &mut TxContext){
    let (treasury_cap, metadata) = coin::create_currency(
      witness,
      8,
      b"PHUQUIIVO03",
      b"Phuquiivo03 Coin",
      b"ayyo phuquivo03 toichoi!",
      option::some(url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/X7KET_iwogbmrgD7ITJE-ZUE6k01TrK8d8AtV4l2FfI")),
      ctx
    );

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
  }

  /// == Manager can mint Coin ==
  public entry fun mint(
        treasury: &mut TreasuryCap<MYCOIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
  }

  /// == Manager can burn Coin ==
  public fun burn(
        treasury: &mut TreasuryCap<MYCOIN>,
        coin: Coin<MYCOIN>,
    ) {
        coin::burn(treasury, coin);
  }

  /// == Test ==
  #[test_only]
  public fun test_init(ctx: &mut TxContext) {
    init(MYCOIN {}, ctx)
  }
}