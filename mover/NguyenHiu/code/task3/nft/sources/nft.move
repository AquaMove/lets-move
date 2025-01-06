module nft::mynft {
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    public struct NguyenHiuNFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    public entry fun mint(name: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext) {
        let nft = NguyenHiuNFT{
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url),
        };

        transfer::transfer(nft, ctx.sender());
    }
}