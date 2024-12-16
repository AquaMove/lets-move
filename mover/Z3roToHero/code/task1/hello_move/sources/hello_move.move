module hello_move::hello_move {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    public struct HelloMove has key, store {
        id: UID,
        github_id: String
    }

    public entry fun create_hello(ctx: &mut TxContext) {
        let github_object = HelloMove {
            id: object::new(ctx),
            github_id: string::utf8(b"Z3roToHero")
        };
        transfer::transfer(github_object, tx_context::sender(ctx))
    }

    public fun get_github_id(hello: &HelloMove): &String {
        &hello.github_id
    }
}