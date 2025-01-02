/// Module: hello_move
module task1_phuquivo::hello_move{
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
        message: string::utf8(b"Ây yo! phuquiivo03 tới chơi!"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }
    /// Function
    entry fun get_message(ctx: &mut TxContext) {
        let message = Message {
        id: object::new(ctx),
        message: string::utf8(b"Hello Move! - this is message sent from phuquiivo03!"),
    };

        transfer::transfer(message, tx_context::sender(ctx));
    }

    /// Function
    #[test_only]
    fun test_hello_move(ctx: &mut TxContext) {
        init(ctx);
    }
}