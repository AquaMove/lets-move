/*
/// Module: move_nft
*/
module move_nft::move_nft {
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct ThaiNFT has key, store {  
        id: UID,
        name: String,
        img_url: Url,
        creator: address,
    }

    fun init(ctx: &mut TxContext) {
        let nft_obj = ThaiNFT {
            id: object::new(ctx),
            name: b"Thai NFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://th.bing.com/th/id/OIP.BP_AHsAu7bBeTfIlR3awFwHaGX?rs=1&pid=ImgDetMain"),
            creator: ctx.sender()
        };
        transfer::transfer(nft_obj,ctx.sender());
    }


    public entry fun mint_nft(ctx: &mut TxContext) {
        transfer::transfer( ThaiNFT {
             id: object::new(ctx),
            name: b"Thai NFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://th.bing.com/th/id/OIP.BP_AHsAu7bBeTfIlR3awFwHaGX?rs=1&pid=ImgDetMain"),
            creator: ctx.sender() 
        }, ctx.sender())
    }
}
