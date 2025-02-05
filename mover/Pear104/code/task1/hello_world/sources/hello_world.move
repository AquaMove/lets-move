module hello_world::hello_world {
 
    use std::string::{Self, String};
 
    /// An object that contains an arbitrary string
    public struct HelloWorldObject has key, store {
        id: UID,
        /// A string contained in the object
        text: string::String
    }
 
    #[lint_allow(self_transfer)]
    public entry fun hello_world(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello World!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
 
    public fun get_text(hello: &HelloWorldObject) : String {
        hello.text
    
    }


}