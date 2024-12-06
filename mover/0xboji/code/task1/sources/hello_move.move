module task1::hello_move {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Public Structs <<<<<<<<<<
    public struct Hello has key {
        id: object::UID,
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

    // >>>>>>>>>> Start Unit tests <<<<<<<<<<
    #[test_only]
    public(package) fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }
    // >>>>>>>>>> End Unit tests <<<<<<<<<<
}
