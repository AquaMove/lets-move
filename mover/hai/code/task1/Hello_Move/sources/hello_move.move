module hello_move::hello{

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    public struct Hello_tranvanhai0504 has key{
        id: UID,
        name: String,
    }

    public entry fun say_hello_haitran(ctx: &mut TxContext){

        let hello_world = Hello_tranvanhai0504 {
            id: object::new(ctx),
            name: b"Hello hai".to_string()
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}