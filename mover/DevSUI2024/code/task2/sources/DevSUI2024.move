module task2::DevSUI2024 {
    use sui::coin::{Self, Coin, TreasuryCap, create_currency};
    use sui::url::{new_unsafe_from_bytes};

    const EAmountLargerThanBalance: u64 = 1;

    public struct DEVSUI2024 has drop {}

    fun init(witness: DEVSUI2024, ctx: &mut TxContext) {
        let (treasuryCap, metadata) = create_currency(witness, 3, b"DEVSUI2024", b"DevSui 2024 Coin", b"Created by DevSUI2024",option::some(new_unsafe_from_bytes(b"https://s3.coinmarketcap.com/static-gravity/image/e0b3ac990f9f4954843dacaf605e0eec.png")) , ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasuryCap, ctx.sender());
    }

    public entry fun mint(cap: &mut TreasuryCap<DEVSUI2024>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint(cap, amount, ctx);
        transfer::public_transfer(coin, ctx.sender());
    }

    public entry fun burn(cap: &mut TreasuryCap<DEVSUI2024>, coin: &mut Coin<DEVSUI2024>, amount: u64, ctx: &mut TxContext) {
        assert!(amount <= coin::value(coin), EAmountLargerThanBalance);

        let burn_coin = coin::split(coin, amount, ctx);
        coin::burn(cap, burn_coin);
    }

    public entry fun total_supply(cap: &TreasuryCap<DEVSUI2024>): u64{
        coin::total_supply(cap)
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(DEVSUI2024{}, ctx);
    }
}

// Transaction digest: 4QefEWr7PDiU2eDDPiH4KezSrHFmwavgZvhsHDHVdQ7n
// Package ID: 0x50448a0f292bb4a35c4926293e53efebd4b9205cdb9a6d5aace7bb7d7e855841
// TreasuryCap ID: 0xbfdccbe469f172f7b4c24d1c4b011d94cb045228cf14bec5a18e6e1e2d4ab4e7
// Metadata ID: 0x31dc8108c990c45eb75912e82efb58b769af94ed08b6a371fa5182ace1c59e57