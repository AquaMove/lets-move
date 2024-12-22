module my_coin::hieungocnguyen {

    use sui::coin::{Self, TreasuryCap};
    use sui::url::{ new_unsafe };

    public struct HIEUNGOCNGUYEN has drop {}

    fun init(
        witness: HIEUNGOCNGUYEN,
        ctx: &mut TxContext
    ) {
        let url_obj = new_unsafe(std::ascii::string(b"https://raw.githubusercontent.com/hieungocnguyen/lets-move/refs/heads/task-2/mover/hieungocnguyen/images/task_2/token_.png"));
        let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"HIEUNGOCNGUYEN",
            b"hieungocnguyen coin",
            b"Task 2 My Coin",
            option::some(url_obj),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, ctx.sender())
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<HIEUNGOCNGUYEN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }
}
