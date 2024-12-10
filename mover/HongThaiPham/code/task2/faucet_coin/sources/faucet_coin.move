/*
/// Module: faucet_coin
module faucet_coin::faucet_coin;
A Coin that anyone can mint.
*/

module faucet_coin::faucet_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    public struct FAUCET_COIN has drop {}

    public struct TreasuryCapKeeper has key, store {
        id: UID,
        cap: TreasuryCap<FAUCET_COIN>
    }

    fun init(otw: FAUCET_COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw, 
            6,
            b"FCC",
            b"HongThaiPham Faucet Coin",
            b"The Faucet Coin is a coin that anyone can mint.",
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/HongThaiPham/lets-move/refs/heads/task2/mover/HongThaiPham/images/faucet-coin.png")), 
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(TreasuryCapKeeper {
            id: object::new(ctx),
            cap: treasury_cap
        });
    }

    public entry fun mint(keeper: &mut TreasuryCapKeeper, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(&mut keeper.cap, amount, recipient, ctx);
    }

    public fun get_cap(keeper: &TreasuryCapKeeper): &TreasuryCap<FAUCET_COIN> {
        &keeper.cap
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(FAUCET_COIN{}, ctx);
    }

}