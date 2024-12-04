

module hello_move::hello {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    public struct Hello_hien_p has key {
        id: UID,
        name: String,
    } 

    public entry fun say_hello_hien_p(ctx: &mut TxContext){
        let hello_world = Hello_hien_p {
            id: object::new(ctx),
            name: string::utf8(b"hello hien-p")
        };
        
        transfer::transfer(hello_world, tx_context::sender(ctx));
    }

}