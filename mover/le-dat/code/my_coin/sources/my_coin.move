module 0x0::my_coin{
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let(treasury, coinmetada) = coin::create_currency<MY_COIN>(witness, 5, b"LE DAT", b"LE DAT COIN", b"MY_FIRST_COIN", option::none(), ctx);
        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
       let coin_object = coin::mint(treasury, 350000, ctx);
       transfer::public_transfer(coin_object, ctx.sender());
    }

}

sui client call --package 0x2 --module coin --function mint_and_transfer --args 0x54a90775da284ac24e84378780fa67be06b51c3c1c6ceec648cb1de01f072492 10000000 0xfcc5841fe594a0fcfcd8e6fd3d3fc8757a06944d3e042fcb9ffdcae9ba4378c7 --type-args 0x1d5ead28ba3db8bc6bf736b42e0d538d8401209dec13aa9a478d14c49632e3fe::my_coin::MY_COIN