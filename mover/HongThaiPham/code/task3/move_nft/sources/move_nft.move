/*
/// Module: move_nft
module move_nft::move_nft;
*/
module move_nft::move_nft {
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    const GITHUB_ID: vector<u8> = b"HongThaiPham";
    const URL: vector<u8> = b"https://avatars.githubusercontent.com/hongthaipham";

    public struct HongThaiPhamNft has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
        github_id: String,
    }

    /// Get the NFT's `name`
    public fun name(nft: &HongThaiPhamNft): &string::String {
        &nft.name
    }

    /// Get the NFT's `description`
    public fun description(nft: &HongThaiPhamNft): &string::String {
        &nft.description
    }

    /// Get the NFT's `url`
    public fun url(nft: &HongThaiPhamNft): &Url {
        &nft.url
    }

    /// Get the NFT's `github_id`
    public fun github_id(nft: &HongThaiPhamNft): &string::String {
        &nft.github_id
    }

    public entry fun mint(name: vector<u8>, description: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let mut nft_name = GITHUB_ID.to_string();
        nft_name.append(b" ".to_string());
        nft_name.append(name.to_string());
        let nft = HongThaiPhamNft {
            id: object::new(ctx),
            name: nft_name,
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(URL),
            github_id: string::utf8(GITHUB_ID),
        };

        transfer::public_transfer(nft, recipient);
    }
}