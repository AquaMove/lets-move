module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Hello_nguyenthidieu2k3 has key {
    id: UID,
    name: String,
    }

    public entry fun say_hello_to_nguyenthidieu2k3(ctx: &mut TxContext) {
        let hello_world = Hello_nguyenthidieu2k3 {
        id: object::new(ctx),
        name: string::utf8(b"Hello nguyenthidieu2k3"),
    };
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}
