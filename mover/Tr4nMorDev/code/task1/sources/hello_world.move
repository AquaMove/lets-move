/*
/// Module: task1
module task1::task1;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module task1::hello {
    
    use sui::object::{Self, UID};    
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};
    public struct Tr4nMorDev has key {
        id: UID,
        name: String,
    }
    public entry fun say_hello_github (ctx: &mut TxContext){
        let hello_move: Tr4nMorDev = Tr4nMorDev {
            id: object::new(ctx),
            name: string::utf8(b"hello Tr4n"),
        };
        transfer::transfer(hello_move ,tx_context::sender(ctx));
    }
}