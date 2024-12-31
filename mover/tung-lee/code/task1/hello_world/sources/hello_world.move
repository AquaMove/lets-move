module hello_world::hello_world {
    use std::string;
    use sui::object;
    use sui::transfer;
    use sui::tx_context;
 
    public struct HelloWorldObject has key, store {
        id: UID,
        github_id: string::String
    }
 
    #[lint_allow(self_transfer)]
    public entry fun hello_world(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            github_id: string::utf8(b"tung-lee")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
}