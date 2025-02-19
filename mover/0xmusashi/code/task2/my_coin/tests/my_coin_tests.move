#[test_only]
module my_coin::my_coin_tests;
// uncomment this line to import the module
use my_coin::my_coin::{MY_COIN, init_for_testing, mint};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use sui::coin::{TreasuryCap, total_supply};
#[test]
fun test_my_coin_admin_mint() {
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    // Initialize the scenario with Alice as the sender
    let mut scenario = test_scenario::begin(alice);
    {
        init_for_testing(test_scenario::ctx(&mut scenario))
    };

    // Mint 10,000,000,000 MY_COIN to Bob by Alice
    test_scenario::next_tx(&mut scenario, alice);
    {
        let mut tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        mint(&mut tc, 10000000000, bob, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(tc);
    };

    // Check the total supply of MY_COIN
    test_scenario::next_tx(&mut scenario, alice);
    {
        let tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        let total_supply = total_supply(&tc);
        assert_eq(total_supply, 10000000000);
        scenario.return_to_sender(tc);
    };

    // Transfer minting permission to Bob
    test_scenario::next_tx(&mut scenario, alice);
    {
        let tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        transfer::public_transfer(tc, bob);  
    };

    // Mint 10,000,000,000 MY_COIN to Charlie by Bob
    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        mint(&mut tc, 10000000000, charlie, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(tc);
    };

    // Check the total supply of MY_COIN
    test_scenario::next_tx(&mut scenario, bob);
    {
        let tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        let total_supply = total_supply(&tc);
        assert_eq(total_supply, 20000000000);
        scenario.return_to_sender(tc);
    };

    test_scenario::end(scenario);
}

#[test]
#[expected_failure]
fun test_my_coin_mint_by_other_fail() {
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    // Initialize the scenario with Alice as the sender
    let mut scenario = test_scenario::begin(alice);
    {
        init_for_testing(test_scenario::ctx(&mut scenario))
    };

    // Mint 10,000,000,000 MY_COIN to Charlie by Bob (should fail)
    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        mint(&mut tc, 10000000000, charlie, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(tc);
    };

    test_scenario::end(scenario);
}