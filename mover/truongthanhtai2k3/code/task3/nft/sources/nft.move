module 0x0::task3{

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct Truongthanhtai2k3NFT has key, store {  
        id: UID,
        name: String,
        img_url: Url,
        creator: address,
    }

    fun init(ctx: &mut TxContext) {
        let nft_obj = Truongthanhtai2k3NFT {
            id: object::new(ctx),
            name: b"Truongthanhtai2k3NFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/198735603?v=4"),
            creator: ctx.sender()
        };
        transfer::transfer(nft_obj,ctx.sender());
    }

    public entry fun mint_nft(ctx: &mut TxContext) {
        transfer::transfer( Truongthanhtai2k3NFT {
            id: object::new(ctx),
            name: b"Truongthanhtai2k3NFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/198735603?v=4"),
            creator: ctx.sender() 
        }, ctx.sender())
    }

     public entry fun transfer_nft(
        nft: Truongthanhtai2k3NFT, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        transfer::transfer(nft, recipient);
    }
}
