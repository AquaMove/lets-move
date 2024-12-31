/*
/// Module: my_nft
module my_nft::my_nft;
*/

module 0x0::my_nft {

    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::tx_context::{TxContext};

    public struct GitNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    
    fun init(ctx: &mut TxContext) {
        let nft = GitNFT {
            id: object::new(ctx),
            name: b"tung-lee".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/87592549?v=4"),
            creator: ctx.sender()
        };

        transfer::transfer(nft, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(GitNFT {
            id: object::new(ctx),
            name: b"tung-lee".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/87592549?v=4"),
            creator: ctx.sender()
        }, ctx.sender());
    }
}
