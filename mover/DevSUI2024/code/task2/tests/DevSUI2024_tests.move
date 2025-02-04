#[test_only]
module task2::DevSUI2024_tests {
    use sui::coin::{Self, TreasuryCap};
    use sui::test_scenario::{Self, EEmptyInventory};
    use task2::DevSUI2024::{Self, DEVSUI2024, init_for_testing, EAmountLargerThanBalance};

    const EWRONG_MINTED_AMOUNT : u64 = 2;
    const EWRONG_TOTAL_SUPPLY : u64 = 4;

    #[test]
    fun test_mint() {
        let dummy_address = @0xA1;
        let mut scenario = test_scenario::begin(dummy_address); 
        {
            init_for_testing(scenario.ctx());
        };

        scenario.next_tx(dummy_address); 
        {
            let mut treasuryCap = scenario.take_from_sender<TreasuryCap<DEVSUI2024>>();
            let amount = 1000;
            task2::DevSUI2024::mint(&mut treasuryCap, amount, scenario.ctx());
            
            scenario.return_to_sender(treasuryCap);
            
        };

        // Test amount of minted coin
        scenario.next_tx(dummy_address); 
        {
            let minted_coin = scenario.take_from_sender<coin::Coin<DEVSUI2024>>();
            let amount = 1000;

            assert!(coin::value(&minted_coin) == amount, EWRONG_MINTED_AMOUNT);
            scenario.return_to_sender(minted_coin);
        };

        // Check total supply
        scenario.next_tx(dummy_address);
        {
            let treasuryCap = scenario.take_from_sender<TreasuryCap<DEVSUI2024>>();
            let total_supply = coin::total_supply(&treasuryCap);
            let amount = 1000;

            assert!(total_supply == amount, EWRONG_TOTAL_SUPPLY);

            scenario.return_to_sender(treasuryCap);
        };

        scenario.end();
    }

    // Check authentication of minting coin
    #[test]
    #[expected_failure(abort_code = EEmptyInventory)]
    fun test_mint_auth() {
        let alice = @0xA123;
        let bob = @0xB456;

        let mut scenario = test_scenario::begin(alice);
        {
            init_for_testing(scenario.ctx());
        };

        scenario.next_tx(bob); 
        {
            let mut treasuryCap = scenario.take_from_sender<TreasuryCap<DEVSUI2024>>();
            let amount = 1000;
            DevSUI2024::mint(&mut treasuryCap, amount, scenario.ctx());

            scenario.return_to_sender(treasuryCap);

        };


        scenario.end();
    }
}

