/*
/// Module: task3
module task3::task3;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module 0x0::task3{

    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct GitNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address,
    }

    fun init(ctx: &mut TxContext){
        let obj = GitNFT{
            id: object::new(ctx),
            name: b"GitNFT".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREH8eOkHxsELIF5Ztbh9Q5_SznwHUU3bWncQ&s"),
            creator: ctx.sender(),
        };

        transfer::transfer(obj, ctx.sender());
    }

    public entry fun mint(ctx: &mut TxContext){
        let obj = GitNFT{
            id: object::new(ctx),
            name: b"HaiNFT".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREH8eOkHxsELIF5Ztbh9Q5_SznwHUU3bWncQ&s"),
            creator: ctx.sender(),
        };

        transfer::transfer(obj, ctx.sender());
    }
}