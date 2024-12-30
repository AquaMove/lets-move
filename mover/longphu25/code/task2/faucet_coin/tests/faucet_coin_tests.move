/*
#[test_only]
module faucet_coin::faucet_coin_tests;
// uncomment this line to import the module
// use faucet_coin::faucet_coin;

const ENotImplemented: u64 = 0;

#[test]
fun test_faucet_coin() {
    // pass
}

#[test, expected_failure(abort_code = ::faucet_coin::faucet_coin_tests::ENotImplemented)]
fun test_faucet_coin_fail() {
    abort ENotImplemented
}
*/


#[test_only]
module faucet_coin::faucet_coin_tests;
// uncomment this line to import the module
use faucet_coin::faucet_coin::{init_for_testing, mint, TreasuryCapKeeper, get_cap};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use sui::coin::{total_supply};

#[test]
fun test_faucet_coin() {

    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    let mut scenario = test_scenario::begin(alice);
    {
        init_for_testing(test_scenario::ctx(&mut scenario))
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        mint(&mut keeper, 1001, charlie, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(keeper);
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        let cap = get_cap(&keeper);
        let total_supply = total_supply(cap);
        assert_eq(total_supply, 1001);
        test_scenario::return_shared(keeper);
    };

    test_scenario::next_tx(&mut scenario, charlie);
    {
        let mut keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        mint(&mut keeper, 1001, alice, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(keeper);
    };

    test_scenario::next_tx(&mut scenario, charlie);
    {
        let keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        let cap = get_cap(&keeper);
        let total_supply = total_supply(cap);
        assert_eq(total_supply, 2002);
        test_scenario::return_shared(keeper);
    };

    test_scenario::end(scenario);
}