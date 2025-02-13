module hello_nhatlapross::hello_world {
    use std::string;
 
    /// An object that contains an arbitrary string
    public struct Hello_nhatlapross has key, store {
        id: UID,
        /// A string contained in the object
        text: string::String
    }
 
    #[lint_allow(self_transfer)]
    public entry fun say_hello_nhatlapross(ctx: &mut TxContext) {
        let object = Hello_nhatlapross {
            id: object::new(ctx),
            text: string::utf8(b"Hello handsome boy,Nhat!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
 
}