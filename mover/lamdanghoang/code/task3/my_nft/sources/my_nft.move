/*
/// Module: my_nft
module my_nft::my_nft;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module 0x0::my_nft {

    use std::string::{String};
    use sui::url::{Self, Url};

    public struct MyNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address,
    }

    // init
    fun init(ctx: &mut TxContext) {
    
        let obj = MyNFT {
            id: object::new(ctx),
            name: b"MyGithub".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://images.nationalgeographic.org/image/upload/v1638882786/EducationHub/photos/sun-blasts-a-m66-flare.jpg"),
            creator: ctx.sender(),
        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(MyNFT {
            id: object::new(ctx),
            name: b"LamDangHoangNFT".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://images.nationalgeographic.org/image/upload/v1638882786/EducationHub/photos/sun-blasts-a-m66-flare.jpg"),
            creator: ctx.sender(),
        }, 
        ctx.sender())
    }

}
