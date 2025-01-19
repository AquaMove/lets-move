module faucet_coin::faucet_coin{
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext){
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
        transfer::public_share_object(treasury);
      }

      public entry fun mint(treasury: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) 
      {
          coin::mint_and_transfer(treasury, amount, recipient, ctx);
      }

      public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext){
          let coin_object = coin::mint(treasury, 35000, ctx);
          transfer::public_transfer(coin_object, ctx.sender());
        }
  }
