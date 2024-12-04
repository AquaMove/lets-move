module hello_move::hello_move  {
    use std::string;

    public struct HelloMoveObject has key, store {
        id: UID,
        text: string::String
    }
 
    #[lint_allow(self_transfer)]
    public entry fun hello_move(ctx: &mut TxContext) {
        let object = HelloMoveObject {
            id: object::new(ctx),
            text: string::utf8(b"hieungocnguyen")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

    public fun get_text(hello: &HelloMoveObject) : string::String {
    hello.text
}
 
}
