module hieungocnguyen_faucet_coin::hieungocnguyen_faucet {

    use sui::coin::{Self, TreasuryCap};
    // use sui::url::{ new_unsafe };

    public struct HIEUNGOCNGUYEN_FAUCET has drop {}

    fun init(
        witness: HIEUNGOCNGUYEN_FAUCET,
        ctx: &mut TxContext
    ) {
        // let url_obj = new_unsafe(std::ascii::string(b""));
        let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"HIEUNGOCNGUYEN_FAUCET",
            b"hieungocnguyen Faucet Coin",
            b"Task 2 Faucet Coin",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, ctx.sender())
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<HIEUNGOCNGUYEN_FAUCET>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }
}
