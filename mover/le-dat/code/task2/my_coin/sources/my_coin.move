module my_coin::my_coin {
    use sui::coin::{Self, TreasuryCap};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetada) = coin::create_currency(
            witness,
            5,
            b"Dav",
            b"MyCoin",
            b"MyCoin",
            option::none(),
            ctx,
        );

        transfer::public_freeze_object(coinmetada);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public entry fun mint_token(treasury_cap: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury_cap, 100000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }

    #[test_only]
    use sui::coin::Coin;

    #[test_only]
    public fun mint_for_testing(value: u64, ctx: &mut TxContext): Coin<MY_COIN> {
        coin::mint_for_testing<MY_COIN>(value, ctx)
    }
}