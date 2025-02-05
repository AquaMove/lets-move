module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_dunseithastry has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_dunseithastry(ctx: &mut TxContext) {
        let hello_world = Hello_dunseithastry {
        id: object::new(ctx),
        name: string::utf8(b"Hello dunseithastry"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}
