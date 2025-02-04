module task3::NFT {
    use std::string::{String};
    use sui::url::{Self, Url};

    public struct DevSUI2024_NFT has key, store {
        id: UID,
        name: String,
        description: String,
        creator: address,
        url: Url
    }

    public entry fun mint(ctx: &mut TxContext) {
        let nft = DevSUI2024_NFT{
            id: object::new(ctx),
            name: b"DevSUI2024 NFT".to_string(),
            description: b"NFT is created in Sui Hackcamp 2024".to_string(),
            creator: ctx.sender(),
            url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/191926815?v=4")
        };

        transfer::public_transfer(nft, ctx.sender());
    }

    public entry fun get_name(nft: &DevSUI2024_NFT) : String {
        nft.name
    }

    public entry fun get_description(nft: &DevSUI2024_NFT) : String {
        nft.description
    }
}

// Transaction digest: 3MzYd7sF18FXk8AXhuF8NPWWS6NeZTLg6K789MRRu2zb
// Package ID: 0x1975194a237ab942cdc2f9c7cb9747fd52f9a64025368f9c44fd70f53e1e8385
// Object ID: 0x2cc1b8c7dfa6e2ac8ce98e8705713dea66acf1d8c6af46874aa6b579da0f3935
