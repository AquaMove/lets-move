module nft_coin::nft_coin {
    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct GitNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    fun init(ctx: &mut TxContext) {
        let obj = GitNFT {
            id: object::new(ctx),
            name: b"wolf".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://cdn.britannica.com/07/5207-050-5BC9F251/Gray-wolf.jpg"),
            creator: ctx.sender()
        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(GitNFT {
            id: object::new(ctx),
            name: b"wolf".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://cdn.britannica.com/07/5207-050-5BC9F251/Gray-wolf.jpg"),
            creator: ctx.sender()
        }, ctx.sender())
    }
    
}



