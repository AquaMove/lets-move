/*
/// Module: faucetcoin
module faucetcoin::faucetcoin;
*/
/*
/// Module: my_coin
module my_coin::my_coin;
*/

module faucetcoin::faucetcoin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    public struct FAUCETCOIN has drop {}

    fun init(otw: FAUCETCOIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw, 
            6,
            b"PQD",
            b"PQD Coin",
            b"PQD Coin is a coin that only specific addresses can mint.",
            option::some(url::new_unsafe_from_bytes(b"http://localhost:3000/PQD")), 
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint(tc: &mut TreasuryCap<FAUCETCOIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(tc, amount, recipient, ctx);
    }


    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(FAUCETCOIN{}, ctx);
    }
}