// hello_move.move
module hello_move::hello {
  use std::string::String;

  public struct HelloMoveObject has key {
    id: UID,
    message: String,
  }
  
  public entry fun hello(ctx: &mut TxContext) {
    let hello_move = HelloMoveObject {
      id: object::new(ctx),
      message: b"hello codingandcoffeerighthand".to_string()
    };
    transfer::transfer(hello_move, tx_context::sender(ctx))
  }
}