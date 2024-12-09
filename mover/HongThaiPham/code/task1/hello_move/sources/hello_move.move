/*
/// Module: hello_move
module hello_move::hongthaipham;
*/

module hello_move::hongthaipham {
    use std::string::{Self, String};
    
    // Struct to store the GitHub ID
    public struct GitHubStruct has key, store {
        id: UID,
        github_id: String,
    }

    public entry fun say_hello(ctx: &mut TxContext) {
        let my_github_object = GitHubStruct {
            id: object::new(ctx),
            github_id: string::utf8(b"HongThaiPham"),
        };

        transfer::transfer(my_github_object, tx_context::sender(ctx));
    }

    public fun github_id(github_object: &GitHubStruct): String {
        github_object.github_id
    }
} 