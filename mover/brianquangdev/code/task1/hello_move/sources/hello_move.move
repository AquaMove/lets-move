

module hello_move::brianquangdev {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_brianquangdev has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_brianquangdev(ctx: &mut TxContext) {
        let hello_world = Hello_brianquangdev {
        id: object::new(ctx),
        name: string::utf8(b"Hello brianquangdev"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}