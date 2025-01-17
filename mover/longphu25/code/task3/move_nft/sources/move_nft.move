/*
/// Module: move_nft
module move_nft::move_nft;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

/*
- Complete the study of NFT-related concepts.
- Deploy a contract on the mainnet that allows minting of NFTs.
- Mint an NFT to your own address.
- The NFT image must be your GitHub avatar.
- Mint an NFT and send it to the address: `0xa9ddd77d41119bdcbab0f5c4d18bf15e65034607afc5a296865f640e0d33d958`
- Submit a screenshot of the blockchain explorer showing the NFT minted to your own address.
*/

module move_nft::move_nft {
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    const GITHUB_ID: vector<u8> = b"longphu25";
    const URL: vector<u8> = b"https://avatars.githubusercontent.com/longphu25";

    public struct StructNFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
        github_id: String,
    }

    /// Get the NFT's `name`
    public fun name(nft: &StructNFT): &string::String {
        &nft.name
    }

    /// Get the NFT's `description`
    public fun description(nft: &StructNFT): &string::String {
        &nft.description
    }

    /// Get the NFT's `url`
    public fun url(nft: &StructNFT): &Url {
        &nft.url
    }

    /// Get the NFT's `github_id`
    public fun github_id(nft: &StructNFT): &string::String {
        &nft.github_id
    }

    public entry fun mint(name: vector<u8>, description: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let mut nft_name = GITHUB_ID.to_string();
        nft_name.append(b" ".to_string());
        nft_name.append(name.to_string());
        let nft = StructNFT {
            id: object::new(ctx),
            name: nft_name,
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(URL),
            github_id: string::utf8(GITHUB_ID),
        };

        transfer::public_transfer(nft, recipient);
    }
}
