module task1::hello_move {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Public Structs <<<<<<<<<<
    public struct Hello has key {
        id: UID,
        say: String
    }
    // >>>>>>>>>> End Public Structs <<<<<<<<<<

    // >>>>>>>>>> Start INIT Functions <<<<<<<<<<
    fun init(ctx: &mut TxContext) {
        let hello_move = Hello {
            id: object::new(ctx),
            say: string::utf8(b"Hello AquaMove from 0xboji.sui"),
        };
        transfer::transfer(hello_move, tx_context::sender(ctx));
    }
    // >>>>>>>>>> End INIT Functions <<<<<<<<<<

    // >>>>>>>>>> Start Public Functions <<<<<<<<<<
    public entry fun set_message(hello: &mut Hello, new_message: vector<u8>) {
        hello.say = string::utf8(new_message);
    }

    public fun get_message(hello: &Hello): &String {
        &hello.say
    }
    // >>>>>>>>>> End Public Functions <<<<<<<<<<

    // >>>>>>>>>> Start Unit tests <<<<<<<<<<
    #[test_only]
    public(package) fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }

    #[test]
    fun test_set_get_message() {
        use sui::test_scenario;
        
        let admin = @0xBABE;
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;
        
        // Initialize the contract
        test_scenario::next_tx(scenario, admin);
        {
            init_for_testing(test_scenario::ctx(scenario));
        };

        // Test setting and getting message
        test_scenario::next_tx(scenario, admin);
        {
            let hello = test_scenario::take_from_sender<Hello>(scenario);
            set_message(&mut hello, b"New message");
            assert!(*string::bytes(get_message(&hello)) == b"New message", 0);
            test_scenario::return_to_sender(scenario, hello);
        };
        
        test_scenario::end(scenario_val);
    }
    // >>>>>>>>>> End Unit tests <<<<<<<<<<
}
