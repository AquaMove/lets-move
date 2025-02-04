module 0x0::task3{
    use std::string::{Self, String};
    use sui::url::{Self, Url}; 
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    public struct GitNFT has key, store{
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }
    fun init(ctx: &mut TxContext){

        let obj = GitNFT {
            id: object::new(ctx),
            name: b"Creeper".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/159614501?s=96&v=4"),
            creator: ctx.sender()
        };
        transfer::transfer(obj, ctx.sender());

    }
    public entry fun mint ( ctx : &mut TxContext){
        transfer::transfer(GitNFT {
            id: object::new(ctx),
            name: b"Creeper".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/159614501?s=96&v=4"),
            creator: ctx.sender()
        }, ctx.sender());
    }
}
