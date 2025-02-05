module 0x0::task3 {

    use std::string::{Self,String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::url::{Self, Url};

    public struct GitNFT has key, store { 
        id: UID,
        name: String,
        image_url: Url,
        creator: address,
    }

    fun init(ctx: &mut TxContext) {
        let git_nft = GitNFT {
            id: object::new(ctx),
            name: b"git-nft".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/107944687?v=4"),
            creator: ctx.sender(),
        };
        transfer::transfer(git_nft, ctx.sender());
    }

    public entry fun mint(ctx : &mut TxContext) {
        let git_nft = GitNFT {
            id: object::new(ctx),
            name: b"git-nft".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/107944687?v=4"),
            creator: ctx.sender(),
        };
        transfer::transfer(git_nft, ctx.sender());
    }

    public entry fun transfer_nft(
        nft: GitNFT, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        transfer::transfer(nft, recipient);
    }
}