#[test_only]
module swap::test_NguyenHiu {
    use my_coin::my_coin::{Self, MY_COIN};
    use my_faucet_coin::my_faucet_coin::{Self, MY_FAUCET_COIN};
    use sui::coin::{Self, Coin};
    use sui::test_scenario::{Self as ts, Scenario as SC};
    use swap::NguyenHiu::{Self as swap, Pool, NGUYENHIU};

    #[test_only]
    fun total_balance<T>(sc: &mut SC): u64 {
        let mut s = 0;
        let ids = ts::ids_for_address<Coin<T>>(@0xCAFE);
        let mut i = 0;
        while (i < vector::length(&ids)) {
            let id = *vector::borrow(&ids, i);
            ts::next_tx(sc, @0xCAFE);
            let c = ts::take_from_address_by_id<Coin<T>>(sc, @0xCAFE, id);
            s = s + c.value();
            ts::return_to_address(@0xCAFE, c);
            ts::next_tx(sc, @0xCAFE);
            i = i + 1;
        };
        ts::next_tx(sc, @0xCAFE);

        s
    }

    #[test]
    fun test_add_liquidity() {
        // Setup
        let mut sc = ts::begin(@0x0);

        // Init module
        swap::init_for_testing(ts::ctx(&mut sc));

        // Mint
        ts::next_tx(&mut sc, @0xCAFE);
        let token_x_balance = 12345;
        let token_y_balance = 9876;
        transfer::public_transfer(
            my_coin::mint_for_testing(token_x_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );
        transfer::public_transfer(
            my_faucet_coin::mint_for_testing(token_y_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );

        // Get Pool instance
        let mut pool_ins = ts::take_shared<Pool>(&sc);

        // Add liquidity 1
        ts::next_tx(&mut sc, @0xCAFE);
        let mut cafe_balance_x = ts::take_from_address<Coin<MY_COIN>>(&sc, @0xCAFE);
        let mut cafe_balance_y = ts::take_from_address<Coin<MY_FAUCET_COIN>>(&sc, @0xCAFE);
        {
            // Split coin before adding liquidity
            let added_token_x = coin::split(&mut cafe_balance_x, 100, ts::ctx(&mut sc));
            let added_token_y = coin::split(&mut cafe_balance_y, 200, ts::ctx(&mut sc));

            swap::add_liquidity(&mut pool_ins, added_token_x, added_token_y, ts::ctx(&mut sc));
        };

        // Check if liquiditiy provider tokens are minted correctly
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let lp_token = ts::take_from_address<Coin<NGUYENHIU>>(&sc, @0xCAFE);
            assert!(lp_token.value() == 300, 0);
            ts::return_to_address(@0xCAFE, lp_token);
        };

        // Add liquidity 2
        ts::next_tx(&mut sc, @0xCAFE);
        {
            // Split coin before adding liquidity
            let added_token_x = coin::split(&mut cafe_balance_x, 10, ts::ctx(&mut sc));
            let added_token_y = coin::split(&mut cafe_balance_y, 20, ts::ctx(&mut sc));

            swap::add_liquidity(&mut pool_ins, added_token_x, added_token_y, ts::ctx(&mut sc));
        };

        // Check if liquiditiy provider tokens are minted correctly
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let balance = total_balance<NGUYENHIU>(&mut sc);
            assert!(balance == 330, 1);
        };

        // Clean up
        ts::return_shared(pool_ins);
        ts::return_to_address(@0xCAFE, cafe_balance_x);
        ts::return_to_address(@0xCAFE, cafe_balance_y);
        ts::end(sc);
    }

    #[test]
    fun test_swap() {
        // Setup
        let mut sc = ts::begin(@0x0);

        // Init module
        swap::init_for_testing(ts::ctx(&mut sc));

        // Mint
        ts::next_tx(&mut sc, @0xCAFE);
        let token_x_balance = 12345;
        let token_y_balance = 9876;
        transfer::public_transfer(
            my_coin::mint_for_testing(token_x_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );
        transfer::public_transfer(
            my_faucet_coin::mint_for_testing(token_y_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );

        // Get Pool instance
        let mut pool_ins = ts::take_shared<Pool>(&sc);

        // Add liquidity
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let mut cafe_balance_x = ts::take_from_address<Coin<MY_COIN>>(&sc, @0xCAFE);
            let mut cafe_balance_y = ts::take_from_address<Coin<MY_FAUCET_COIN>>(&sc, @0xCAFE);
            {
                // Split coin before adding liquidity
                let added_token_x = coin::split(&mut cafe_balance_x, 100, ts::ctx(&mut sc));
                let added_token_y = coin::split(&mut cafe_balance_y, 200, ts::ctx(&mut sc));

                ts::next_tx(&mut sc, @0xCAFE);
                swap::add_liquidity(&mut pool_ins, added_token_x, added_token_y, ts::ctx(&mut sc));
            };

            // Return coin objects back to CAFE
            ts::return_to_address(@0xCAFE, cafe_balance_x);
            ts::return_to_address(@0xCAFE, cafe_balance_y);

            // Check if liquidity provider tokens are minted correctly
            ts::next_tx(&mut sc, @0xCAFE);
            {
                let lp_token = ts::take_from_address<Coin<NGUYENHIU>>(&sc, @0xCAFE);
                assert!(lp_token.value() == 300, 0);
                ts::return_to_address(@0xCAFE, lp_token);
            };
        };

        // Swap Tokens 1: 10 X --> ~ 19 Y
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let mut cafe_balance_x = ts::take_from_address<Coin<MY_COIN>>(&sc, @0xCAFE);
            let cafe_balance_y = ts::take_from_address<Coin<MY_FAUCET_COIN>>(&sc, @0xCAFE);
            let y_balance_origin = cafe_balance_y.value();
            swap::swap_x_to_y(
                &mut pool_ins,
                coin::split(&mut cafe_balance_x, 10, ts::ctx(&mut sc)),
                10,
                ts::ctx(&mut sc),
            );

            // Return coin objects back to CAFE
            ts::return_to_address(@0xCAFE, cafe_balance_x);
            ts::return_to_address(@0xCAFE, cafe_balance_y);

            // Check if tokens change correctly
            ts::next_tx(&mut sc, @0xCAFE);
            {
                let balance = total_balance<MY_FAUCET_COIN>(&mut sc);
                assert!(balance - y_balance_origin == 19, 0);
            };
        };

        // Swap Tokens 2: 20 Y --> ~ 11 X
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let cafe_balance_x = ts::take_from_address<Coin<MY_COIN>>(&sc, @0xCAFE);
            let mut cafe_balance_y = ts::take_from_address<Coin<MY_FAUCET_COIN>>(&sc, @0xCAFE);
            let x_balance_origin = cafe_balance_x.value();
            swap::swap_y_to_x(
                &mut pool_ins,
                coin::split(&mut cafe_balance_y, 20, ts::ctx(&mut sc)),
                10,
                ts::ctx(&mut sc),
            );

            // Return coin objects back to CAFE
            ts::return_to_address(@0xCAFE, cafe_balance_x);
            ts::return_to_address(@0xCAFE, cafe_balance_y);

            // Check if tokens change correctly
            ts::next_tx(&mut sc, @0xCAFE);
            {
                let balance = total_balance<MY_COIN>(&mut sc);
                assert!(balance - x_balance_origin == 11, 0);
            };
        };

        // Clean up
        ts::return_shared(pool_ins);
        ts::end(sc);
    }

    #[test]
    fun test_remove_liquidity() {
        // Setup
        let mut sc = ts::begin(@0x0);

        // Init module
        swap::init_for_testing(ts::ctx(&mut sc));

        // Mint
        ts::next_tx(&mut sc, @0xCAFE);
        let token_x_balance = 12345;
        let token_y_balance = 9876;
        transfer::public_transfer(
            my_coin::mint_for_testing(token_x_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );
        transfer::public_transfer(
            my_faucet_coin::mint_for_testing(token_y_balance, ts::ctx(&mut sc)),
            @0xCAFE,
        );

        // Get Pool instance
        let mut pool_ins = ts::take_shared<Pool>(&sc);

        // Add liquidity
        ts::next_tx(&mut sc, @0xCAFE);
        let mut cafe_balance_x = ts::take_from_address<Coin<MY_COIN>>(&sc, @0xCAFE);
        let mut cafe_balance_y = ts::take_from_address<Coin<MY_FAUCET_COIN>>(&sc, @0xCAFE);
        {
            // Split coin before adding liquidity
            let added_token_x = coin::split(&mut cafe_balance_x, 100, ts::ctx(&mut sc));
            let added_token_y = coin::split(&mut cafe_balance_y, 200, ts::ctx(&mut sc));

            ts::next_tx(&mut sc, @0xCAFE);
            swap::add_liquidity(&mut pool_ins, added_token_x, added_token_y, ts::ctx(&mut sc));
        };

        // Get original tokens for further comparation
        let x_balance_origin = cafe_balance_x.value();
        let y_balance_origin = cafe_balance_y.value();
        let lp_token_origin: u64;
        
        // Check if liquidity provider tokens are minted correctly
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let lp_token = ts::take_from_address<Coin<NGUYENHIU>>(&sc, @0xCAFE);
            lp_token_origin = lp_token.value();
            assert!(lp_token.value() == 300, 0);
            ts::return_to_address(@0xCAFE, lp_token);
        };


        // Return coin objects back to CAFE
        ts::return_to_address(@0xCAFE, cafe_balance_x);
        ts::return_to_address(@0xCAFE, cafe_balance_y);

        // Remove 30 LP Tokens
        ts::next_tx(&mut sc, @0xCAFE);
        {
            // Split Tokens
            let mut lp_tokens = ts::take_from_address<Coin<NGUYENHIU>>(&sc, @0xCAFE);
            let burn_tokens = coin::split(&mut lp_tokens, 30, ts::ctx(&mut sc));
            ts::next_tx(&mut sc, @0xCAFE);
            swap::remove_liquidity(&mut pool_ins, burn_tokens, ts::ctx(&mut sc));
            ts::return_to_address(@0xCAFE, lp_tokens);
        };

        // Check if tokens change correctly
        ts::next_tx(&mut sc, @0xCAFE);
        {
            let balance = total_balance<MY_FAUCET_COIN>(&mut sc);
            assert!(balance - y_balance_origin == 20, 0);
        };
        {
            let balance = total_balance<MY_COIN>(&mut sc);
            assert!(balance - x_balance_origin == 10, 1);
        };
        {
            let balance = total_balance<NGUYENHIU>(&mut sc);
            assert!(lp_token_origin - balance == 30, 2);
        };

        // Clean up
        ts::return_shared(pool_ins);
        ts::end(sc);
    }
}
