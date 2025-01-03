/// Module: hello_world
module hello_world::hello {
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    public struct Hello_vanthaita has key {
        id: UID,
        name: String,
    }

    public entry fun say_hello_to_vanthaita(ctx: &mut TxContext) {
        let hello_world = Hello_vanthaita {
            id: object::new(ctx),
            name: b"Hello Thai Ta".to_string(),
        };
        let sender = tx_context::sender(ctx);
        transfer::transfer(hello_world, sender);
    }
}
