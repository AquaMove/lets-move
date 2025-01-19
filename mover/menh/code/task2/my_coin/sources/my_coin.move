module my_coin::my_coin{
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext){
        let(treasury, coinmetada) = coin::create_currency(
        witness,
        5,
        b"MENH", 
        b"Menh Coin",
        b"My first amazing coin",
        option::none(),
        ctx
        );

        transfer::public_freeze_object(coinmetada);
        transfer::public_transfer(treasury, ctx.sender());
      }

      public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
      }

      public fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext){
          let coin_object = coin::mint(treasury, 35000, ctx);
          transfer::public_transfer(coin_object, ctx.sender());
      }
  }

  //package: 0x1dd6c4e05b4ce3ed051a477e7bd5639ae087a7bb92caee76cb8fdcbd1f2ed500
  //treasury: 0xe44e6376b030a101f0a62c38de49452967f1f55ff7a05b0f7a9703ae652c040f
