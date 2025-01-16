module task1::hello_move;

use std::string::{Self, String};

public struct Hello_Object has key {
    id: UID,
    text: String
}

public entry fun hello_word(ctx: &mut TxContext) {
    let hello_object = Hello_Object{
        id: object::new(ctx),
        text: string::utf8(b"Hello DevSUI2024")
    };

    transfer::transfer(hello_object, ctx.sender());
}

public entry fun get_text(hello_obj: &Hello_Object) : String {
    hello_obj.text
}

// Transaction digest: 4iQs8uJQMtR2cQyw4moXNhTpEwv9xas7NK1XaipGhJEB
// Package ID: 0x1dcbab68d7ee7192e8e1259726b51318cfe07e99b91dd0112902c4cc73017999