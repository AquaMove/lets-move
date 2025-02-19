
module 0x0::create_nft {

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::url::{Self, Url}; 
    use sui::tx_context::{Self, TxContext};

    public struct GitNFT has key, store {

        id: UID,
        name: String,
        image_url: Url,
        creator: address

    }

    fun init(ctx: &mut TxContext) {
        let obj = GitNFT {
            id: object::new(ctx),
            name: b"toantri".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://tse1.mm.bing.net/th?id=OIP.CGk72oKzc6G4n4wC5bEZhAHaDX&pid=Api&P=0&h=180"),
            creator: ctx.sender()
        };

        transfer::transfer(obj, ctx.sender());
    }
    public entry fun mint_nft(ctx: &mut TxContext) {
        transfer::transfer(GitNFT{
            id: object::new(ctx),
            name: b"toantri".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://tse1.mm.bing.net/th?id=OIP.CGk72oKzc6G4n4wC5bEZhAHaDX&pid=Api&P=0&h=180"),
            creator: ctx.sender()
        }, ctx.sender())
    }

    public entry fun transfer_nft(
        nft: GitNFT, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        transfer::transfer(nft, recipient);
    }
}

