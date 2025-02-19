module hello_move::hello {
    use std::string::String;

    public struct Hello_NguyenHiu has key {
        id: UID,
        name: String,
    }

    public fun say_hello_NguyenHiu(ctx: &mut TxContext) {
        let hello_world = Hello_NguyenHiu {
            id: object::new(ctx),
            name: b"Hello NguyenHiu".to_string(),
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}