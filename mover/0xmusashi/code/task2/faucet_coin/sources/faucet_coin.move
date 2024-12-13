module faucet_coin::musashi {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    public struct MUSASHI has drop {}

    fun init(otw: MUSASHI, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            6,
            b"MUSASHI",
            b"MUSASHI Faucet Coin",
            b"Anyone can mint $MUSASHI.",
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/0xmusashi/lets-move/refs/heads/main/mover/0xmusashi/images/samurai.jpg")), 
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    public entry fun mint(cap: &mut TreasuryCap<MUSASHI>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(cap, amount, recipient, ctx);
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(MUSASHI{}, ctx);
    }
}