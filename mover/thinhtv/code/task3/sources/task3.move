
/// Module: task3
module task3::task3 {

    use std::string::{String};
    use sui::url::{Self, Url};
    use sui::transfer::{Self};

    public struct GitNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    
    fun init(ctx: &mut TxContext) {
        let obj = GitNFT {
            id: object::new(ctx),
            name: b"GitNFT".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/16848468?v=4&size=64"),
            creator: ctx.sender()
        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(GitNFT {
            id: object::new(ctx),
            name: b"gitCoin:mint".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/16848468?v=4&size=64"),
            creator: ctx.sender()
        }, ctx.sender());
    }
}