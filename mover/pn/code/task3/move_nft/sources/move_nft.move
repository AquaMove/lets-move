/*
/// Module: move_nft
module move_nft::move_nft;
*/
module move_nft::move_nft {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// An example NFT that can be minted by anybody
    public struct MoveNFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
    }

    // ===== Events =====

    public struct NFTMinted has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    /// Get the NFT's `name`
    public fun name(nft: &MoveNFT): &string::String {
        &nft.name
    }

    /// Get the NFT's `description`
    public fun description(nft: &MoveNFT): &string::String {
        &nft.description
    }

    /// Get the NFT's `url`
    public fun url(nft: &MoveNFT): &Url {
        &nft.url
    }

    /// Create a new devnet_nft
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = MoveNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::transfer(nft, sender);
    }

    /// Transfer `nft` to `recipient`
    public entry fun transfer(
        nft: MoveNFT, recipient: address, _: &mut TxContext
    ) {
        transfer::transfer(nft, recipient)
    }   
}
