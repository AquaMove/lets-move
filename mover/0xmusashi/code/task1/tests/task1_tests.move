#[test_only]
module task1::hello_world_tests {

    #[test]
    fun test_hello_world() {
        use sui::test_scenario;
        use sui::test_utils::assert_eq;
        use task1::hello_world::{HelloWorldObject, hello_world};
        use std::string;

        let dummy_address = @0xCAFE;

        let mut scenario = test_scenario::begin(dummy_address);
        {
            hello_world(scenario.ctx());
        };

        scenario.next_tx(dummy_address);
        {
            let hello = scenario.take_from_sender<HelloWorldObject>();
            let text = hello.get_text();
            std::debug::print(&text);
            assert_eq(text, string::utf8(b"Hello 0xmusashi"));

            scenario.return_to_sender(hello)
        };

        scenario.end();
    }
}