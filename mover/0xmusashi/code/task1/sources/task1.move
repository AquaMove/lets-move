module task1::hello_world {
    use std::string::{Self, String};

    public struct HelloWorldObject has key, store {
        id: UID,
        text: string::String
    }

    #[lint_allow(self_transfer)]
    public entry fun hello_world(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello 0xmusashi")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

    public fun get_text(hello: &HelloWorldObject) : String {
        hello.text
    }
}