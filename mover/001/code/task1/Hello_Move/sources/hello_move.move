module 0x0::hello_move {
    use sui::object;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    public struct Hello has key {
        id: object::UID,
        say: String
    }
 
    /// Hàm tạo đối tượng Hello và gửi nó đến người gọi
    public entry fun create_hello(ctx: &mut TxContext) {
        let hello_move = Hello {
            id: object::new(ctx),
            say: string::utf8(b"Hello AquaMove from AnhQuan2004.sui"),
        };
        transfer::transfer(hello_move, tx_context::sender(ctx));
    }

    #[test_only]
    public(package) fun init_for_testing(ctx: &mut TxContext) {
        create_hello(ctx)
    }
}
