/*
/// Module: my_nft
module my_nft::my_nft;
*/

module my_nft::nft_kDam {

    use sui::url::{Self, Url};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::{Self, String};

    public struct GitNFT has store, key {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
        creator: address, 
    }


    //init 

    fun init (ctx: &mut TxContext){

        let obj = GitNFT{
            id: object::new(ctx),
            name: b"KhoaNFT".to_string(),
            description: b"PENGU so cute".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/736x/21/1e/3b/211e3b2a0ccc6d7edb7f7b14289d3735.jpg"),
            creator: ctx.sender()

        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext){
        transfer::transfer(
            GitNFT{
            id: object::new(ctx),
            name: b"KhoaNFT".to_string(),
            description: b"PENGU so cute".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/736x/21/1e/3b/211e3b2a0ccc6d7edb7f7b14289d3735.jpg"),
            creator: ctx.sender()
            }, 
            ctx.sender()
        );
    }

    // public entry fun transfer_nft(nft: &mut GitNFT, recipient: address){
    //     transfer::transfer(nft, recipient);
    // }

}