#[test_only]
module hello_move::hello_move_tests;
 
#[test]
fun test_hello_move() {
    use sui::test_scenario;
    use sui::test_utils::assert_eq;
    use hello_move::hello_move::{HelloMoveObject, hello_move};
    use std::string;
    let dummy_address = @0xCAFE;

    let mut scenario = test_scenario::begin(dummy_address);
        {
            hello_move(scenario.ctx());
        };
 
    scenario.next_tx(dummy_address);
    {
        let hello = scenario.take_from_sender<HelloMoveObject>();
        let text = hello.get_text();
        std::debug::print(&text);
        assert_eq(text, string::utf8(b"hieungocnguyen"));

        scenario.return_to_sender(hello)
    };
 
    scenario.end();
     
}
