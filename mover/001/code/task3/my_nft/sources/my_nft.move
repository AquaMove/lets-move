/*
/// Module: my_nft
module my_nft::my_nft;
*/

module 0x0::my_nft {

    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct GitNFT has store, key {
        id: UID,
        name: String,
        image_url: Url,
        creator: address, 
    }


    //init 

    fun init (ctx: &mut TxContext){

        let obj = GitNFT{
            id: object::new(ctx),
            name: b"KhoaNFT".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/736x/21/1e/3b/211e3b2a0ccc6d7edb7f7b14289d3735.jpg"),
            creator: ctx.sender()

        };

        transfer::transfer(obj, ctx.sender());
    }
}