#[test_only]
module task1::hello_move_tests {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::test_scenario;
    use task1::hello_move::{Self, Hello};
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Tests <<<<<<<<<<
    #[test]
    fun test_hello_move_creation() {
        let owner = @0xA;
        let mut scenario = test_scenario::begin(owner);
        
        {
            hello_move::init_for_testing(test_scenario::ctx(&mut scenario));
        };

        test_scenario::next_tx(&mut scenario, owner);
        {
            assert!(test_scenario::has_most_recent_for_sender<Hello>(&scenario), 0);
            let hello = test_scenario::take_from_sender<Hello>(&scenario);
            test_scenario::return_to_sender(&scenario, hello);
        };

        test_scenario::end(scenario);
    }
    // >>>>>>>>>> End Tests <<<<<<<<<<
}
