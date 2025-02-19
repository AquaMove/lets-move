/*
/// Module: hello_move
module hello_move::hello_move;
author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module hello_move::hello_move;

use std::string::{Self, String};

/// An object that contains an arbitrary string
public struct Hello_nhoc20170861 has key, store {
    id: UID,
    /// A string contained in the object
    text: string::String,
}

#[lint_allow(self_transfer)]
public entry fun hello_move(ctx: &mut TxContext) {
    let object = Hello_nhoc20170861 {
        id: object::new(ctx),
        text: string::utf8(b"Hello World Sui! I'm nhoc20170861"),
    };
    transfer::public_transfer(object, tx_context::sender(ctx));
}

#[test_only]
public fun get_text(hello: &Hello_nhoc20170861): String {
    hello.text
}
