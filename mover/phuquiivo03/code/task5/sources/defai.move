module task5::defai{
  use sui::coin::{Self, Coin, TreasuryCap};
  use sui::url::{Self};

  // == Define Struct ==
  public struct DEFAI has drop {}

  fun init(witness: DEFAI, ctx: &mut TxContext){
    let (treasury_cap, metadata) = coin::create_currency(
      witness,
      8,
      b"DEFAI",
      b"Phuquiivo03 Coin",
      b"ayyo phuquivo03 toichoi!",
      option::some(url::new_unsafe_from_bytes(b"https://dd.dexscreener.com/ds-data/tokens/arbitrum/0x13ad3f1150db0e1e05fd32bdeeb7c110ee023de6.png?size=lg&key=d5dae4")),
      ctx
    );

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
  }

  /// == Manager can mint Coin ==
  public entry fun mint(
        treasury: &mut TreasuryCap<DEFAI>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
  }

  /// == Manager can burn Coin ==
  public fun burn(
        treasury: &mut TreasuryCap<DEFAI>,
        coin: Coin<DEFAI>,
    ) {
        coin::burn(treasury, coin);
  }

  /// == Test ==
  #[test_only]
  public fun test_init(ctx: &mut TxContext) {
    init(DEFAI {}, ctx)
  }
}