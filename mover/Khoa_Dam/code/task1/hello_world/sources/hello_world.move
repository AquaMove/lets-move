module hello_move::khoaddev{
    use std::string::{Self, String};

    public struct GithubStruct has key, store {
        id: UID,
        github_id: String,
    }

    public entry fun say_hello(ctx: &mut TxContext){
        let my_github_object = GithubStruct{
            id: object::new(ctx),
            github_id: string::utf8(b"khoaddev"),   
        };

    transfer::transfer(my_github_object, tx_context::sender(ctx));

    }

    public fun github_id(github_object: &GithubStruct): String{
        github_object.github_id
    }
    
}