// tests/faucet_coin_tests.move

#[test_only]
module faucet_coin::faucet_coin_tests;

#[test]
fun test_faucet_coin() {
    use sui::test_scenario;

    use faucet_coin::faucet_coin::{FAUCET_COIN, init_for_testing, mint_token};
    use sui::coin::{TreasuryCap};

    let dummy_address = @0xCAFE;

    // First transaction executed by initial owner to create the sword
    let mut scenario = test_scenario::begin(dummy_address);
    {
        // Create hello world
        init_for_testing(scenario.ctx());
    };

    scenario.next_tx(dummy_address);
    {
        let wallet_address = @0x1e1;
        let mut tc = test_scenario::take_from_sender<TreasuryCap<FAUCET_COIN>>(&scenario);
        mint_token(&mut tc, 10000000000, wallet_address, test_scenario::ctx(&mut scenario));
        scenario.return_to_sender(tc);
    };

    scenario.end();
}
