
#[test_only]
module move_game::move_game_tests;
// uncomment this line to import the module
use move_game::onetwothree::{play, take_reward, Game, init_for_testing as init_game, get_game_balance, new_game};
use faucet_coin::faucet_coin::{init_for_testing, mint, TreasuryCapKeeper, FAUCET_COIN};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use sui::coin;
use sui::random::{Self, Random};

// const EInvalidAmount: u64 = 0;

#[test]
fun test_move_game() {
    let admin = @0x0;
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    let mut scenario = test_scenario::begin(admin);
    {
        random::create_for_testing(scenario.ctx());
       
    };

    test_scenario::next_tx(&mut scenario, admin);
    {
        let mut random_state: Random = scenario.take_shared();
        random_state.update_randomness_state_for_testing(
            0,
            x"1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F",
            scenario.ctx(),
        );

        test_scenario::return_shared(random_state);
    };

    test_scenario::next_tx(&mut scenario, alice);
    {
        init_game(test_scenario::ctx(&mut scenario));
        init_for_testing(test_scenario::ctx(&mut scenario))
    
    };

    test_scenario::next_tx(&mut scenario, alice);
    {
        let mut keeper = test_scenario::take_shared<TreasuryCapKeeper>(&scenario);
        mint(&mut keeper, 10000000000, bob, test_scenario::ctx(&mut scenario));
        mint(&mut keeper, 10000000000, charlie, test_scenario::ctx(&mut scenario));
        test_scenario::return_shared(keeper);
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut coin = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, bob);
        let coin_to_bet = coin::split(&mut coin, 1000000000, test_scenario::ctx(&mut scenario));
        new_game(coin_to_bet, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(coin);
       
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let game = test_scenario::take_from_sender<Game>(&scenario);
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 1000000000);
        scenario.return_to_sender(game);
    };


    test_scenario::next_tx(&mut scenario, charlie);
    {
        let mut game = test_scenario::take_from_address<Game>(&scenario, bob);
        // get coin object from bob balance
        let mut coin = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);

        // split coin object to 2 coin object with value 1000000000
        let coin_to_play = coin::split(&mut coin, 1000000000, test_scenario::ctx(&mut scenario));
        let choice: u8 = 1;

        let random_state: Random = scenario.take_shared();
        play(&random_state, &mut game, coin_to_play, choice, test_scenario::ctx(&mut scenario));

        // check game balance
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 2000000000);
 
        scenario.return_to_sender(coin);
        test_scenario::return_to_address(bob, game);
        test_scenario::return_shared(random_state);  
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let mut game = test_scenario::take_from_address<Game>(&scenario, bob);
        // get coin object from bob balance
        let mut coin = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);

        // split coin object to 2 coin object with value 1000000000
        let coin_to_play = coin::split(&mut coin, 3000000000, test_scenario::ctx(&mut scenario));
        let choice: u8 = 1;

        let random_state: Random = scenario.take_shared();
        
        play(&random_state, &mut game, coin_to_play, choice, test_scenario::ctx(&mut scenario));

        // check game balance
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 5000000000);
 
        scenario.return_to_sender(coin);
        test_scenario::return_to_address(bob, game);
        test_scenario::return_shared(random_state);  
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let game = test_scenario::take_from_address<Game>(&scenario, bob);
        take_reward(game, test_scenario::ctx(&mut scenario));
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let game = test_scenario::take_from_address<Game>(&scenario, bob);
        scenario.next_epoch(bob);

        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 0);

        // check bob balance FAUCET_COIN
        let coin = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, bob);

        assert_eq(coin.value(), 5000000000);
        scenario.return_to_sender(coin);
        test_scenario::return_to_address(bob, game);

    };

    // test_scenario::next_tx(&mut scenario, bob);
    // {
    //     let coin = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, bob);
    //     assert_eq(coin.value(), 1000000000);
    //     scenario.return_to_sender(coin);
    // };

    test_scenario::end(scenario);
}

// #[test, expected_failure(abort_code = ::move_game::move_game_tests::ENotImplemented)]
// fun test_move_game_fail() {
//     abort ENotImplemented
// }

