
#[test_only]
#[allow(unused_use)]
module move_swap::move_swap_tests;
// uncomment this line to import the module
use move_swap::hongthaipham_swap::{add_liquidity, Pair, init_for_testing, HONGTHAIPHAM_SWAP, remove_liquidity, calculate_x_y_amount_return, swap_to_y, swap_to_x,  calculate_desired_amount_withdraw};
use faucet_coin::faucet_coin::{init_for_testing as init_faucet_coin, mint as mint_faucet_coin, TreasuryCapKeeper, FAUCET_COIN};
use my_coin::my_coin::{init_for_testing as init_my_coin, mint as mint_my_coin, MY_COIN};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use sui::coin::{Self, TreasuryCap};
use std::debug;


const INIT_BALANCE_X: u64 = 1000_000_000;
const INIT_BALANCE_Y: u64 = 500_000_000;
const MINIMUM_LIQUIDITY: u64 = 1000;


#[test]
fun test_move_swap() {
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;
    let swaper = @0x1e3;

   
    let mut scenario = test_scenario::begin(alice);

    test_scenario::next_tx(&mut scenario, alice);
    {
        init_faucet_coin(test_scenario::ctx(&mut scenario));
        init_my_coin(test_scenario::ctx(&mut scenario));
        init_for_testing(test_scenario::ctx(&mut scenario));
    };


    // mint token for bob and charlie
    test_scenario::next_tx(&mut scenario, alice);
    {
        let mut keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        mint_faucet_coin(&mut keeper, 10_000_000_000, bob, test_scenario::ctx(&mut scenario));
        mint_faucet_coin(&mut keeper, 10_000_000_000, charlie, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(keeper);

        let mut tc = test_scenario::take_from_sender<TreasuryCap<MY_COIN>>(&scenario);
        mint_my_coin(&mut tc, 10000000000, bob, test_scenario::ctx(&mut scenario));
        mint_my_coin(&mut tc, 10000000000, charlie, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(tc);
    };

    test_scenario::next_tx(&mut scenario, alice);
    {
        let pair = test_scenario::take_shared<Pair>(&scenario);
        assert_eq(pair.balance_x(), 0);
        assert_eq(pair.balance_y(), 0);
        test_scenario::return_shared(pair);
    };


    // bob add liquidity
    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut pair = test_scenario::take_shared<Pair>(&scenario);
        let mut coin_x = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, bob);
        let mut coin_x_to_add = coin::split(&mut coin_x, INIT_BALANCE_X, test_scenario::ctx(&mut scenario));

        let mut coin_y = test_scenario::take_from_address<coin::Coin<MY_COIN>>(&scenario, bob);
        let mut coin_y_to_add = coin::split(&mut coin_y, INIT_BALANCE_Y, test_scenario::ctx(&mut scenario));

        add_liquidity(&mut pair, &mut coin_x_to_add, INIT_BALANCE_X, &mut coin_y_to_add, INIT_BALANCE_Y, test_scenario::ctx(&mut scenario));

        scenario.return_to_sender(coin_x);
        transfer::public_transfer(coin_x_to_add, bob);
        scenario.return_to_sender(coin_y);
        transfer::public_transfer(coin_y_to_add, bob);
        test_scenario::return_shared(pair);
    };

    test_scenario::next_epoch(&mut scenario, bob);
    test_scenario::next_tx(&mut scenario, bob);
    {
        let pair = test_scenario::take_shared<Pair>(&scenario);
        assert_eq(pair.balance_x(), INIT_BALANCE_X);
        assert_eq(pair.balance_y(), INIT_BALANCE_Y);

        let lp_total_supply = pair.lp_total_supply();

        assert_eq(lp_total_supply, std::u64::sqrt(INIT_BALANCE_X * INIT_BALANCE_Y) as u64);

        test_scenario::return_shared(pair);

        let coin_lp = test_scenario::take_from_address<coin::Coin<HONGTHAIPHAM_SWAP>>(&scenario, bob);
        assert_eq(coin::value(&coin_lp), std::u64::sqrt(INIT_BALANCE_X * INIT_BALANCE_Y) as u64 - MINIMUM_LIQUIDITY); 
        scenario.return_to_sender(coin_lp);

        
    };

    // charlie add liquidity
    test_scenario::next_epoch(&mut scenario, charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let mut pair = test_scenario::take_shared<Pair>(&scenario);
        let mut coin_x = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);
        let mut coin_x_to_add = coin::split(&mut coin_x, 500000000, test_scenario::ctx(&mut scenario));

        let mut coin_y = test_scenario::take_from_sender<coin::Coin<MY_COIN>>(&scenario);
        let mut coin_y_to_add = coin::split(&mut coin_y, 1000000000, test_scenario::ctx(&mut scenario));

        add_liquidity(&mut pair, &mut coin_x_to_add, 500000000, &mut coin_y_to_add, 1000000000, test_scenario::ctx(&mut scenario));

        scenario.return_to_sender(coin_x);
        transfer::public_transfer(coin_x_to_add, charlie);
        scenario.return_to_sender(coin_y);
        transfer::public_transfer(coin_y_to_add, charlie);
        test_scenario::return_shared(pair);
    };

    test_scenario::next_epoch(&mut scenario, charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let pair = test_scenario::take_shared<Pair>(&scenario);
        assert_eq(pair.balance_x(), 1500000000);
        assert_eq(pair.balance_y(), 750000000);

        let lp_total_supply = pair.lp_total_supply();

        assert_eq(lp_total_supply, 1060660171);

        test_scenario::return_shared(pair);

        let coin_lp = test_scenario::take_from_sender<coin::Coin<HONGTHAIPHAM_SWAP>>(&scenario);
        assert_eq(coin::value(&coin_lp), 353553390); 
        scenario.return_to_sender(coin_lp);
        
    };

    // bob remove liquidity
    test_scenario::next_epoch(&mut scenario, bob);
    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut pair = test_scenario::take_shared<Pair>(&scenario);
        let reserve_x = pair.balance_x();
        let reserve_y = pair.balance_y();

        let lp_total_supply_before = pair.lp_total_supply();

        let coin_lp = test_scenario::take_from_sender<coin::Coin<HONGTHAIPHAM_SWAP>>(&scenario);
        let shares = coin_lp.value();

        let (amount_x, amount_y) = calculate_x_y_amount_return(reserve_x, reserve_y, shares, lp_total_supply_before);
    
        remove_liquidity(&mut pair, coin_lp, test_scenario::ctx(&mut scenario));

        test_scenario::return_shared(pair);


        test_scenario::next_epoch(&mut scenario, bob);

        let pair = test_scenario::take_shared<Pair>(&scenario);
        let lp_total_supply = pair.lp_total_supply();
        assert_eq(lp_total_supply == lp_total_supply_before - shares, true);

        let coin_x = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);
        let coin_y = test_scenario::take_from_sender<coin::Coin<MY_COIN>>(&scenario);

        assert_eq(coin_x.value(), amount_x);
        assert_eq(coin_y.value(), amount_y);

        scenario.return_to_sender(coin_x);
        scenario.return_to_sender(coin_y);
        test_scenario::return_shared(pair);
    };

    // mint token for swaper
    test_scenario::next_tx(&mut scenario, alice);
    {
        let mut keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        mint_faucet_coin(&mut keeper, 1_000_000_000, swaper, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(keeper);
    };

    // test swap to y
    test_scenario::next_tx(&mut scenario, swaper);
    {
        let mut pair = test_scenario::take_shared<Pair>(&scenario);
        let reserve_x = pair.balance_x();
        let reserve_y = pair.balance_y();


        let mut coin_x = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);
        let coin_x_value_before = coin_x.value();

        let coin_x_value_swap = 1000000;
        let coint_x_to_swap = coin::split(&mut coin_x, coin_x_value_swap, test_scenario::ctx(&mut scenario));
        

        transfer::public_transfer(coin_x, swaper);

        let amount_y_received = calculate_desired_amount_withdraw(reserve_x, reserve_y, coin_x_value_swap);


        swap_to_y(&mut pair, coint_x_to_swap, amount_y_received-1, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(pair);

        test_scenario::next_epoch(&mut scenario, swaper);
        let coin_y = test_scenario::take_from_sender<coin::Coin<MY_COIN>>(&scenario);
        assert_eq(coin_y.value(), amount_y_received);

        let coin_x = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);
        let coin_x_value = coin_x.value();

        assert_eq(coin_x_value, coin_x_value_before - coin_x_value_swap);

        scenario.return_to_sender(coin_x);

        scenario.return_to_sender(coin_y);
    };

    // test swap to x
    test_scenario::next_epoch(&mut scenario, swaper);
    test_scenario::next_tx(&mut scenario, swaper);
    {
        let mut pair = test_scenario::take_shared<Pair>(&scenario);
        let reserve_x = pair.balance_x();
        let reserve_y = pair.balance_y();


        let mut coin_y = test_scenario::take_from_sender<coin::Coin<MY_COIN>>(&scenario);
        let coin_y_value_before = coin_y.value();

        let coin_y_value_swap = 400000;
        let coint_y_to_swap = coin::split(&mut coin_y, 400000, test_scenario::ctx(&mut scenario));


        transfer::public_transfer(coin_y, swaper);

        let amount_x_received = calculate_desired_amount_withdraw(reserve_y, reserve_x, coin_y_value_swap);


        swap_to_x(&mut pair, coint_y_to_swap, amount_x_received-1, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(pair);

        test_scenario::next_epoch(&mut scenario, swaper);
        let coin_x = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);
        assert_eq(coin_x.value(), amount_x_received);

        let coin_y = test_scenario::take_from_sender<coin::Coin<MY_COIN>>(&scenario);
        let coin_y_value = coin_y.value();

        assert_eq(coin_y_value, coin_y_value_before - coin_y_value_swap);

        scenario.return_to_sender(coin_x);
        scenario.return_to_sender(coin_y);
    };

   
    test_scenario::end(scenario);
}

// #[test, expected_failure(abort_code = ::move_swap::move_swap_tests::ENotImplemented)]
// fun test_move_swap_fail() {
//     abort ENotImplemented
// }

