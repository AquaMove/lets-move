module 0x0::my_coin {
    use sui::coin::{Self, TreasuryCap};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmeta) = coin::create_currency(
            witness,
            5,
            b"shogun",
            b"shogun coin",
            b"First coin",
            option::none(),
            ctx
        );

        transfer::public_freeze_object(coinmeta);
        transfer::public_transfer(treasury, ctx.sender());

    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 10000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
        
    }
}