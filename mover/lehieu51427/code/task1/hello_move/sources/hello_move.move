module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_lehieu51427 has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_lehieu51427(ctx: &mut TxContext) {
        let hello_world = Hello_lehieu51427 {
        id: object::new(ctx),
        name: string::utf8(b"Hello Le Hieu"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}