module hello_move::hello {

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    public struct Hello_thinhtv has key{
        id: UID,
        name: String,
    }

    public entry fun say_hello_thinhtv(ctx: &mut TxContext) {
        let hello_world = Hello_thinhtv {
            id: object::new(ctx),
            name: b"Hello thinhtv".to_string()
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}