#[test_only]
module task1::hello_move_test;

use task1::hello_move::{Self, Hello_Object};
use sui::test_scenario::{Self, EEmptyInventory};

const EWRONG_TEXT : u64 = 1;

#[test]
fun test_hello_move() {
    let dummy_address = @0xA1;

    let mut scenario = test_scenario::begin(dummy_address);
    {
        hello_move::hello_word(scenario.ctx());
    };

    scenario.next_tx(dummy_address);
    {
        let hello_obj = scenario.take_from_sender<Hello_Object>();
        assert!(hello_move::get_text(&hello_obj) == b"Hello DevSUI2024".to_string(), EWRONG_TEXT);

        scenario.return_to_sender(hello_obj);
    };

    scenario.end();
}

#[test]
#[expected_failure(abort_code = EEmptyInventory)]
fun test_hello_move_fail() {
    let dummy_addr = @0xA1;

    let mut scenario = test_scenario::begin(dummy_addr);
    {
        let hello_obj = scenario.take_from_sender<Hello_Object>();
        scenario.return_to_sender(hello_obj);
    };

    scenario.end();
}

