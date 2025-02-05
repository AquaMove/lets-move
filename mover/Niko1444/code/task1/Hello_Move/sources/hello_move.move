/*
/// Module: hello_move
module hello_move::hello_move;
*/

module hello_move::hello_move {
 
    use std::string;
 
    /// An object that contains an arbitrary string
    public struct SayHelloObject has key, store {
        id: UID,
        /// A string contained in the object
        text: string::String
    }
 
    #[lint_allow(self_transfer)]
    public entry fun say_hello_Niko1444(ctx: &mut TxContext) {
        let object = SayHelloObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello Niko1444 !!!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
 
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


