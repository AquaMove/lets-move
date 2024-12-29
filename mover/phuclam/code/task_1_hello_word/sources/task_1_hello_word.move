/*
/// Module: task_1_hello_word
module task_1_hello_word::task_1_hello_word;
*/
module task_1_hello_word::task_1_hello_word{

    use std::string;

    public struct HelloWordObj has key, store{
        id:UID,
        text: string::String,
    }
    #[lint_allow(self_transfer)]
    public entry fun hello_word(ctx: &mut TxContext){
        let object = HelloWordObj{
            id: object::new(ctx),
            text: string::utf8(b"Hello, World!"),
        };
        transfer::public_transfer(object,tx_context::sender(ctx));
    }
}