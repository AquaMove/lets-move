module nft::nft {
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    const AVATAR_URL: vector<u8> = b"https://avatars.githubusercontent.com/0xmusashi";

    public struct Nft has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    public fun name(nft: &Nft): &string::String {
        &nft.name
    }

    public fun description(nft: &Nft): &string::String {
        &nft.description
    }

    public fun url(nft: &Nft): &Url {
        &nft.url
    }

    public entry fun mint(name: vector<u8>, description: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let nft = Nft {
            id: object::new(ctx),
            name: name.to_string(),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(AVATAR_URL),
        };

        transfer::public_transfer(nft, recipient);
    }
}