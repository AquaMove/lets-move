/*
/// Module: my_nft
module my_nft::my_nft;
*/

module my_nft::NFT_ICHI {

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
            name: b"A GIFT TO HG".to_string(),
            description: b"HG so cute".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcT5KDQD850WxwdMk1GSc0cuRS-9jZ5PTT9W3beXcasS33cL2i6P"),
            creator: ctx.sender()

        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext){
        transfer::transfer(
            GitNFT{
            id: object::new(ctx),
            name: b"HG GIFT".to_string(),
            description: b"HG so cute".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcT5KDQD850WxwdMk1GSc0cuRS-9jZ5PTT9W3beXcasS33cL2i6P"),
            creator: ctx.sender()
            }, 
            ctx.sender()
        );
    }

  
}