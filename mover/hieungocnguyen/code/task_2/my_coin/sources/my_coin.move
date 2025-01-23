module my_coin::my_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::url::{ new_unsafe };

    public struct MY_COIN has drop {}

    fun init(
        witness: MY_COIN,
        ctx: &mut TxContext
    ) {
        let url_obj = new_unsafe(std::ascii::string(b"https://raw.githubusercontent.com/hieungocnguyen/lets-move/refs/heads/task-2/mover/hieungocnguyen/images/task_2/token_.png"));
        let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"HNN",
            b"My coin - hieungocnguyen",
            b"My coin - Task 2",
            option::some(url_obj),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, ctx.sender())
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<MY_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }
}
