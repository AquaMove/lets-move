module 0x0::hello {
    use std::string::String;

    public struct Hello_shogun has key {
        id: UID,
        name: String,
    }

    public entry fun say_hello_shogun(ctx: &mut TxContext) {
        let hello_world = Hello_shogun {
            id: object::new(ctx),
            name: b"Hello shogun".to_string()
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}