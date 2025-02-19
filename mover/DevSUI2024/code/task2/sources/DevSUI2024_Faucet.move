module task2::DevSUI2024_Faucet {
    use sui::coin::{Self, TreasuryCap, create_currency};
    use sui::url::{new_unsafe_from_bytes};

    public struct DEVSUI2024_FAUCET has drop {}

    fun init(witness: DEVSUI2024_FAUCET, ctx: &mut TxContext) {
        let (treasuryCap, metadata) = create_currency(witness, 3, b"DEVSUI2024_FAUCET", b"DEVSUI2024_FAUCET", b"Created by DevSui2024", option::some(new_unsafe_from_bytes(b"https://imagedelivery.net/4-5JC1r3VHAXpnrwWHBHRQ/75a2cd04-fbe7-4e63-06ae-f0363328c600/w=430,h=242,fit=cover")), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasuryCap);
    }

    public entry fun mint(cap: &mut TreasuryCap<DEVSUI2024_FAUCET>, amount: u64, ctx: &mut TxContext) {
        coin::mint_and_transfer(cap, amount, ctx.sender(), ctx);
    }
}

// Transaction digest: 8SaskLLJMBcW8WcomBgKbATrFTRtM4jSK7U9StD4w1PB
// Package ID: 0x26b55a5cd1f32fb9ccdcc0b4414ca7aeebe75ff5b4d5108e56ca585a483c84dc
// TreasuryCap ID: 0xb2ef68ef70130310c02d134a7328fa1e9dac8e3816634083ea5a65cf1ce7b015
// Metadata ID: 0x92b2f0205782ee1e366e2984afd6e302da5b0188eeb6a5cfc9d748d2658ff141