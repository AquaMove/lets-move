module 0x0::mynft {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    
    public struct GitNFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
        creator: address
    }

    fun init(ctx: &mut TxContext) {
        let obj = GitNFT {
            id: object::new(ctx),
            name: string::utf8(b"Jiren"),
            description: string::utf8(b"A powerful NFT from Dragon Ball Super"),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/originals/4b/ab/80/4bab80d62aa30cce1870ec9b9fb5a7d5.jpg"),
            creator: tx_context::sender(ctx)
        };

        transfer::transfer(obj, tx_context::sender(ctx));
    }

    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(
            GitNFT {
                id: object::new(ctx),
                name: string::utf8(b"Jiren"),
                description: string::utf8(b"A powerful NFT from Dragon Ball Super"),
                image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/originals/4b/ab/80/4bab80d62aa30cce1870ec9b9fb5a7d5.jpg"),
                creator: tx_context::sender(ctx)
            },
            tx_context::sender(ctx)
        )
    }
    public entry fun transfer_nft(nft: GitNFT, recipient: address) {
        transfer::transfer(nft, recipient);
    }
}