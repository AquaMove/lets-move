module my_nft::hieungocnguyen_nft {
    use sui::url::{Self, Url};
    use std::string;

    public struct HIEUNGOCNGUYEN_NFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
    }

    public entry fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {

        let nft = HIEUNGOCNGUYEN_NFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: description.to_string(),
            url: url::new_unsafe_from_bytes(url)
        };

        transfer::public_transfer(nft, ctx.sender());
    }
}
