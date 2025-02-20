/*
/// Module: hello_move
module hello_move::hello_move;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module hello_move::hello {
  use std::string::{String};

  public struct Hello_trunglq04 has key {
    id: UID,
    name: String,
  }

  public entry fun say_hello_trunglq04(ctx: &mut TxContext) {
    let hello_world = Hello_trunglq04 {
      id: object::new(ctx),
      name: b"hello trunglq04".to_string()
    };

    transfer::transfer(hello_world, tx_context::sender(ctx));
  }
}