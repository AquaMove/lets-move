module hello_move::hello;

use std::string::{ Self, String };

public struct HelloMinh20051202 has key {
	id: UID,
	name: String,
}

public entry fun say_hello_minh20051202(ctx: &mut TxContext) {
	let hello = HelloMinh20051202 {
		id: object::new(ctx),
		name: string::utf8(b"Hello minh20051202")
	};

	transfer::transfer(hello, tx_context::sender(ctx));
}