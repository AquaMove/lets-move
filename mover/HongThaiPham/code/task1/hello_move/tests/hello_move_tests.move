
#[test_only]
module hello_move::hongthaipham_tests;
// uncomment this line to import the module
use hello_move::hongthaipham::{GitHubStruct, say_hello, github_id};
use sui::test_scenario;
use std::string;
use sui::test_utils::assert_eq;

#[test]
fun test_call_say_hello_hongthaipham() {
    
    let sender = @0x1e0;

    let mut scenario = test_scenario::begin(sender);
    {
        say_hello(test_scenario::ctx(&mut scenario))
    };

    test_scenario::next_tx(&mut scenario, sender);
    {
        let received_object = test_scenario::take_from_sender<GitHubStruct>(&scenario);
        assert_eq(github_id(&received_object), string::utf8(b"HongThaiPham")); 

        scenario.return_to_sender(received_object);
    };

  
    test_scenario::end(scenario);
}

