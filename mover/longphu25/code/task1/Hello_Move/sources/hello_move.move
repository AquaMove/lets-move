/*
/// Module: hello_move
module hello_move::hello_move;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module hello_move::longphu {
    use std::string::{Self, String};

    // Struct to store the GitHub ID
    public struct GitHubStruct has key, store {
        id: UID,
        github_id: String,
    }

    public entry fun say_hello(ctx: &mut TxContext) {
        let hello_world = GitHubStruct {
            id: object::new(ctx),
            github_id: string::utf8(b"Long Phu"),
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }

    public fun github_id(github_object: &GitHubStruct): String {
        github_object.github_id
    }
} 