module hello_move::hello {
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    public struct Hello_gen_gar_vin has key {
        id: UID,
        name: String,
    }

    public fun say_hello_gen_gar_vin(ctx: &mut TxContext) {
        let hello_world = Hello_gen_gar_vin {
            id: object::new(ctx),
            name: b"Hello gen-gar-vin".to_string(),
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}