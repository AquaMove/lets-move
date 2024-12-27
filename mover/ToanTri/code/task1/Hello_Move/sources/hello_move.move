

module hello_move::hello {

    use sui::object::{Self, UID};

    use std::string::{Self, String};

    use sui::tx_context::{Self,TxContext};

    public struct Hello_ToanTri has key {
        id: UID,
        name: String,
    }

    public fun say_hello_ToanTri(ctx: &mut TxContext) {
        let hello_world = Hello_ToanTri {
            id: object::new(ctx),
            name: string::utf8(b"Toan Tri")
        };

    transfer::transfer(hello_world, tx_context::sender(ctx));

    }
}


