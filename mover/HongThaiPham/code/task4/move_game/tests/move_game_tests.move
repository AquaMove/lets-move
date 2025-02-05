
#[test_only]
module move_game::move_game_tests;
// uncomment this line to import the module
use move_game::hongthaipham::{play, take_reward, Game, get_game_balance, new_game, EGameIsNotOver};
use faucet_coin::faucet_coin::{init_for_testing, mint, TreasuryCapKeeper, FAUCET_COIN};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use sui::coin;
use sui::random::{Self, Random};
use std::debug;



#[test]
fun test_move_game() {
    let admin = @0x0;
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    let mut scenario = test_scenario::begin(admin);
   
    random::create_for_testing(scenario.ctx());
       
    test_scenario::next_tx(&mut scenario, admin);
    
    let mut random_state: Random = scenario.take_shared();
    random_state.update_randomness_state_for_testing(
        0,
        b"0x01",
        scenario.ctx(),
    );


    test_scenario::next_tx(&mut scenario, alice);
    {
        // init_game(test_scenario::ctx(&mut scenario));
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
        new_game(coin_to_bet, true, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(coin);
       
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 1_000_000_000);
        assert_eq(game.get_game_even_win(), true);
        test_scenario::return_shared(game);
    };


    test_scenario::next_tx(&mut scenario, charlie);
    {
        let mut game = test_scenario::take_shared<Game>(&scenario);
        // get coin object from bob balance
        let mut coin = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);

        // split coin object to 2 coin object with value 1000000000
        let coin_to_play = coin::split(&mut coin, 1000_000_000, test_scenario::ctx(&mut scenario));
        let choice: u8 = 6;

        // let random_state: Random = scenario.take_shared();
        play(&random_state, &mut game, coin_to_play, choice, test_scenario::ctx(&mut scenario));
        
 
        scenario.return_to_sender(coin);
        test_scenario::return_shared(game);
        // test_scenario::return_shared(random_state);  
    };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 2000_000_000);
        assert_eq(game.get_game_bot(), 2);
        assert_eq(game.get_game_player_choice(), 6);
        assert_eq(game.get_game_lasted_player(), charlie);
        test_scenario::return_shared(game);
    };

    // scenario.next_epoch(charlie);
    // test_scenario::next_tx(&mut scenario, charlie);
    // {
    //     let coin = test_scenario::ids_for_sender<coin::Coin<FAUCET_COIN>>(&scenario);
    //     debug::print(&coin);
    // };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        debug::print(&game);
        take_reward(game, test_scenario::ctx(&mut scenario));
    };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let coin = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, charlie);
        assert_eq(coin.value(), 2000_000_000);
        scenario.return_to_sender(coin);
    };


    test_scenario::return_shared(random_state);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = EGameIsNotOver)]
fun test_move_game_fail() {
    let admin = @0x0;
    let alice = @0x1e0;
    let bob = @0x1e1;
    let charlie = @0x1e2;

    let mut scenario = test_scenario::begin(admin);
   
    random::create_for_testing(scenario.ctx());
       
    test_scenario::next_tx(&mut scenario, admin);
    
    let mut random_state: Random = scenario.take_shared();
    random_state.update_randomness_state_for_testing(
        0,
        b"0x02",
        scenario.ctx(),
    );


    test_scenario::next_tx(&mut scenario, alice);
    {
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
        new_game(coin_to_bet, true, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(coin);
       
    };

    test_scenario::next_tx(&mut scenario, bob);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 1_000_000_000);
        assert_eq(game.get_game_even_win(), true);
        test_scenario::return_shared(game);
    };


    test_scenario::next_tx(&mut scenario, charlie);
    {
        let mut game = test_scenario::take_shared<Game>(&scenario);
        // get coin object from bob balance
        let mut coin = test_scenario::take_from_sender<coin::Coin<FAUCET_COIN>>(&scenario);

        // split coin object to 2 coin object with value 1000000000
        let coin_to_play = coin::split(&mut coin, 1000_000_000, test_scenario::ctx(&mut scenario));
        let choice: u8 = 2;

        play(&random_state, &mut game, coin_to_play, choice, test_scenario::ctx(&mut scenario));
 
        scenario.return_to_sender(coin);
        test_scenario::return_shared(game);
    };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        let game_balance = get_game_balance(&game);
        assert_eq(game_balance, 2000_000_000);
        assert_eq(game.get_game_bot(), 5);
        assert_eq(game.get_game_player_choice(), 2);
        assert_eq(game.get_game_lasted_player(), charlie);
        test_scenario::return_shared(game);
    };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let game = test_scenario::take_shared<Game>(&scenario);
        take_reward(game, test_scenario::ctx(&mut scenario));
    };

    scenario.next_epoch(charlie);
    test_scenario::next_tx(&mut scenario, charlie);
    {
        let coin = test_scenario::take_from_address<coin::Coin<FAUCET_COIN>>(&scenario, charlie);
        assert_eq(coin.value(), 2000_000_000);
        scenario.return_to_sender(coin);
    };


    test_scenario::return_shared(random_state);
    test_scenario::end(scenario);
}

