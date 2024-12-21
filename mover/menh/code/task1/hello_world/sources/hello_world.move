module hello_world::hello_move{

    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    public struct Message has key {
        id: object::UID,
        message: String
    }

    fun init(ctx: &mut TxContext){ 
        let message = Message {
        id: object::new(ctx),
        message: string::utf8(b"Hello SUI. I really love SUI very much"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }
    entry fun get_message(ctx: &mut TxContext) {
        let message = Message {
        id: object::new(ctx),
        message: string::utf8(b"Hi SUI! - this is a message from ThienMenh"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }

    #[test_only]
    fun test_hello_move(ctx: &mut TxContext) {
        init(ctx);
    }
}