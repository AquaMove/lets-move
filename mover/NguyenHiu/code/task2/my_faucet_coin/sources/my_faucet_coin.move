module my_faucet_coin::my_faucet_coin {
    use sui::coin::{Self, TreasuryCap};

    // OTW
    public struct MY_FAUCET_COIN has drop {}

    fun init(witness: MY_FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetada) = coin::create_currency(
            witness,
            5,
            b"NHF",
            b"NguyenHiu Faucet",
            b"NguyenHiu Faucet Coin",
            option::none(),
            ctx,
        );

        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury_cap: &mut TreasuryCap<MY_FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }

    #[test_only]
    use sui::coin::Coin;

    #[test_only]
    public fun mint_for_testing(value: u64, ctx: &mut TxContext): Coin<MY_FAUCET_COIN> {
        coin::mint_for_testing<MY_FAUCET_COIN>(value, ctx)
    }
}