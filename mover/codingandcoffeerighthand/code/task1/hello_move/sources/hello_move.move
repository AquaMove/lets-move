module hello_move::hello_move;

use std::string::String;

public struct Helle_codingandcoffeerighthand has key {
    id: UID,
    name: String,
}

public entry fun say_hello_codingandcoffeerighthand(ctx: &mut TxContext) {
    let hello = Helle_codingandcoffeerighthand {
        id: object::new(ctx),
        name: b"Hello codingandcoffeerighthand".to_string(),
    };
    transfer::transfer(hello, ctx.sender())
}
