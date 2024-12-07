module task2::boji_coin {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::coin::{Self, create_currency, TreasuryCap};
    use std::option::some;
    use sui::url::{Self};
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Structs <<<<<<<<<<
    public struct BOJI_COIN has drop {}
    // >>>>>>>>>> End Structs <<<<<<<<<<

    // >>>>>>>>>> Start INIT Functions <<<<<<<<<<
    fun init(witness: BOJI_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = create_currency(
            witness,
            8,  // decimals
            b"BOJI", // symbol
            b"Boji Coin", // name
            b"This is Boji's test coin on Sui", // description
            some(url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/JSxwDwYWwmZs9AG-UaenzJOBodr0mCwXOI_Ik9XOTXw")),
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx));
    }
    // >>>>>>>>>> End INIT Functions <<<<<<<<<<

    // >>>>>>>>>> Start Public Functions <<<<<<<<<<
    public entry fun mint(
        treasury: &mut TreasuryCap<BOJI_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }
    // >>>>>>>>>> End Public Functions <<<<<<<<<<
}