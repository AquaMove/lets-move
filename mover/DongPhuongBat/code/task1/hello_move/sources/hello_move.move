module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_DongPhuongBat has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_DongPhuongBat(ctx: &mut TxContext) {
        let hello_world = Hello_DongPhuongBat {
        id: object::new(ctx),
        name: string::utf8(b"Hello DongPhuongBat"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}
