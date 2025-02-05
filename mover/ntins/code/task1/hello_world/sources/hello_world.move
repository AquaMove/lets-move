module hello_world::hello {

    use sui::object::{Self,UID};
    use std::string::{Self,String};
    use sui::tx_context::{Self, TxContext};
 
    public struct Tinssss111 has key , store{
        id: UID,
        name: string::String,
    }
 
    public entry fun hello_tinssss111(ctx: &mut TxContext) {
        let hello_world_tinssss111 = Tinssss111 {
            id: object::new(ctx),
            name: string::utf8(b"Hello tinssss111!")
        };
        transfer::public_transfer(hello_world_tinssss111, tx_context::sender(ctx));
    }
}