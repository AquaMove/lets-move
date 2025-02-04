module hello_move::hello_move;

use sui::object::{Self, UID};
use std::string::{Self, String};
use sui::tx_context::{Self, TxContext};

public struct HelloOtis has key {
    id: UID,
    content: String,
}

public entry fun say_hello_otis(ctx: &mut TxContext) {
    let helloOtis = HelloOtis {
        id: object::new(ctx),
        content: string::utf8(b"Hello, Otis!"),
    };
    transfer::transfer(helloOtis, tx_context::sender(ctx));
}
