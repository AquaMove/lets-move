module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_hiennguyen2795 has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_hiennguyen2795(ctx: &mut TxContext) {
        let hello_world = Hello_hiennguyen2795 {
        id: object::new(ctx),
        name: string::utf8(b"Hello hiennguyen2795"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}
