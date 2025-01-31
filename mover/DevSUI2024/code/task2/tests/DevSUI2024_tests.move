#[test_only]
module task2::DevSUI2024_tests {
    use sui::coin::{Self, TreasuryCap};
    use sui::test_scenario;
    use task2::DevSUI2024::{Self, DEVSUI2024, EAmountLargerThanBalance};
    use sui::url::{new_unsafe_from_bytes};

    const EWRONG_MINTED_AMOUNT : u64 = 2;

    #[test]
    fun test_mint() {
        let dummy_address = @0xA1;
        let mut scenario = test_scenario::begin(dummy_address); 
        {
            // Create new coin
            let (treasuryCap, metadata) = coin::create_currency(DEVSUI2024, 3, b"DEVSUI2024", b"DevSui 2024 Coin", b"Created by DevSUI2024",option::some(new_unsafe_from_bytes(b"https://s3.coinmarketcap.com/static-gravity/image/e0b3ac990f9f4954843dacaf605e0eec.png")) , scenario.ctx());

            transfer::public_freeze_object(metadata);
            transfer::public_transfer(treasuryCap, dummy_address);


            //let treasuryCap = &mut scenario.take_from_sender<TreasuryCap<DEVSUI2024>>();
            let amount = 1000;
            task2::DevSUI2024::mint(treasuryCap, amount, scenario.ctx());
            let minted_coin = &scenario.take_from_sender<coin::Coin<DEVSUI2024>>();

            assert!(coin::value(minted_coin) == amount, EWRONG_MINTED_AMOUNT);

            //scenario.return_to_sender(treasuryCap);
            scenario.return_to_sender(*minted_coin);
        };

        scenario.end();
    }
}

