#[test_only]
module game::test_game {
    #[test_only]
    use sui::test_scenario::{Self as ts, Scenario as SC};
    use game::game::{Self, Game, Admin};
    use my_faucet_coin::my_faucet_coin::{Self as fc, MY_FAUCET_COIN as FC};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

    #[test_only]
    fun get_ctx(s: &mut SC): &mut TxContext {
        ts::ctx(s)
    }

    #[test]
    fun test_game() {
        // Setup 
        let admin_addr = @0xCAFE;
        let player_addr = @0x12345;

        let mut sc = ts::begin(@0x0);
        random::create_for_testing(sc.ctx());

        ts::next_tx(&mut sc, @0x0);
        let mut random_state: Random = sc.take_shared();
        random_state.update_randomness_state_for_testing(
            0,
            b"0x01",
            sc.ctx(),
        );

        // Init Game
        ts::next_tx(&mut sc, admin_addr);
        game::init_game(get_ctx(&mut sc));

        // Get Admin and Game
        ts::next_tx(&mut sc, admin_addr);
        let admin_ins = ts::take_from_address<Admin>(&sc, admin_addr);
        let mut game_ins = ts::take_shared<Game>(&sc);

        // Mint FC 
        ts::next_tx(&mut sc, admin_addr);
        transfer::public_transfer(
            fc::mint_for_testing(1000000, get_ctx(&mut sc)),
            admin_addr
        );

        // Admin deposits coins to the pool
        ts::next_tx(&mut sc, admin_addr);
        {
            game::deposit(
                &admin_ins,
                &mut game_ins,
                ts::take_from_address<Coin<FC>>(&sc, admin_addr),
            );
        };

        // Start game
        ts::next_tx(&mut sc, admin_addr);
        {
            game::start_game(
                &admin_ins,
                &mut game_ins
            );
        };

        // Game is active after starting
        assert!(game_ins.get_active_status(), 0);

        // Mint FC
        ts::next_tx(&mut sc, player_addr);
        transfer::public_transfer(
            fc::mint_for_testing(1000000, get_ctx(&mut sc)),
            player_addr
        );
        

        // Play game
        ts::next_tx(&mut sc, player_addr);
        let mut player_balance = ts::take_from_address<Coin<FC>>(&sc, player_addr);
        
        // Get original balance
        let pool_balance_checkpoint_1 = game::get_game_balance(&game_ins);
        let user_balance_checkpoint_1 = coin::value(&player_balance);

        let bet_amount = 100000;
        game::play(
            &random_state,
            &mut game_ins,
            &mut player_balance,
            bet_amount,
            true,
            get_ctx(&mut sc),   
        );

        // Get balance after change
        let user_balance_checkpoint_2 = coin::value(&player_balance);
        let pool_balance_checkpoint_2 = game::get_game_balance(&game_ins);

        // Check
        if (user_balance_checkpoint_2 > user_balance_checkpoint_1) {
            assert!(
                pool_balance_checkpoint_1 - pool_balance_checkpoint_2 
                    == 
                user_balance_checkpoint_2 - user_balance_checkpoint_1,
                0
            );

            assert!(
                user_balance_checkpoint_2 - user_balance_checkpoint_1
                    == 
                bet_amount,
                1
            );
        } else {
            assert!(
                pool_balance_checkpoint_2 - pool_balance_checkpoint_1
                    == 
                user_balance_checkpoint_1 - user_balance_checkpoint_2,
                2
            );
        };

        // Stop game
        ts::next_tx(&mut sc, admin_addr);
        game::end_game(
            &admin_ins,
            &mut game_ins,
        );

        // Check active status
        assert!(!game::get_active_status(&game_ins), 3);

        // Withdraw
        ts::next_tx(&mut sc, admin_addr);
        game::withdraw(
            &admin_ins,
            &mut game_ins,
            get_ctx(&mut sc),
        );

        // Check balance after withdraw
        ts::next_tx(&mut sc, admin_addr);
        let admin_balance = ts::take_from_address<Coin<FC>>(&sc, admin_addr);
        assert!(
            admin_balance.value() == pool_balance_checkpoint_2,
            4
        );

        // Clean up
        ts::return_shared(random_state);
        ts::return_shared(game_ins);
        ts::return_to_address(player_addr, player_balance);
        ts::return_to_address(admin_addr, admin_balance);
        ts::return_to_address(admin_addr, admin_ins);
        ts::end(sc);
    }
}