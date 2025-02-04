module faucet_coin::faucet_coin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::url;

    public struct FAUCET_COIN has drop {}

    fun init(
        witness: FAUCET_COIN,
        ctx: &mut TxContext
    ) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"FHNN",
            b"Faucet coin - hieungocnguyen",
            b"Faucet coin - Task 2",
            option::some(
                url::new_unsafe_from_bytes(
                    b"https://github.com/hieungocnguyen/lets-move/blob/task-2/mover/hieungocnguyen/images/task_2/token_.png?raw=true"
                )
            ),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<FAUCET_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }

    public entry fun burn<T>(
        treasury_cap: &mut TreasuryCap<T>,
        input_coin: Coin<T>,
    ) {
        coin::burn<T>(treasury_cap, input_coin);
    }
}
