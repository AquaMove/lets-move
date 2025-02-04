#[test_only]
module task3::NFT_test {
    use sui::test_scenario::{Self, EEmptyInventory};
    use task3::NFT::{Self, DevSUI2024_NFT, get_name, get_description};

    const E_WRONG_NAME : u64 = 1;
    const E_WRONG_DESCRIPTION : u64 = 2;

    #[test]
    public fun test_mint() {
        let dummy_address = @0x1;
        let mut scenario = test_scenario::begin(dummy_address);
        {
            NFT::mint(scenario.ctx());
        };

        // Must have another txs different from the txn of mint()
        scenario.next_tx(dummy_address);
        {
            let nft = scenario.take_from_sender<DevSUI2024_NFT>();

            assert!(get_name(&nft) == b"DevSUI2024 NFT".to_string(), E_WRONG_NAME);
            assert!(get_description(&nft) == b"NFT is created in Sui Hackcamp 2024".to_string(), E_WRONG_DESCRIPTION);
            scenario.return_to_sender(nft);
        };

        scenario.end();
    }

    #[test]
    #[expected_failure(abort_code = EEmptyInventory)]
    public fun test_mint_failed() {
        let user = @0xA2;
        let mut scenario = test_scenario::begin(user);
        {
            let nft = scenario.take_from_sender<DevSUI2024_NFT>();
            assert!(get_name(&nft) == b"DevSUI2024 NFT".to_string(), E_WRONG_NAME);
            assert!(get_description(&nft) == b"NFT is created in Sui Hackcamp 2024".to_string(), E_WRONG_DESCRIPTION);

            scenario.return_to_sender(nft);
        };

        scenario.end();
    }
}