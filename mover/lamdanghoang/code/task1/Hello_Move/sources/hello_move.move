module hello_move::hello {

    use std::string::{Self, String};
    
    public struct Hello_lamdanghoang has key {
        id: UID,
        name: String,
    }

    public entry fun say_hello_lamdanghoang(ctx: &mut TxContext) {
        let hello_world = Hello_lamdanghoang {
            id: object::new(ctx),
            name: string::utf8(b"Hello lamdanghoang"),
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}