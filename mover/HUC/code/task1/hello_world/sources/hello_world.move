/// Module: hello_move
module 0x0::hello_move{
    /// Import library
    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    /// Define structs
    public struct Message has key {
        id: object::UID,
        message: String
    }

    /// Init function
    fun init(ctx: &mut TxContext){ 
        let message = Message {
        id: object::new(ctx),
        message: string::utf8(b"Hi Sui!"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }
    /// Function
    entry fun get_message(ctx: &mut TxContext) {
        let message = Message {
        id: object::new(ctx),
        message: string::utf8(b"Hello Sui! - this is message sent from HUC!"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }

    /// Function
    #[test_only]
    fun test_hello_move(ctx: &mut TxContext) {
        init(ctx);
    }
}