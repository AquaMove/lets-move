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
            name: b"AnhQuan2004".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/236x/f6/4a/4e/f64a4e6beb67c49f571cc78f8b95fe37--monsters-university-monsters-inc.jpg"),
            creator: ctx.sender()
        };
        transfer::transfer(obj, ctx.sender());

    }

    public entry fun mint ( ctx : &mut TxContext){
        transfer::transfer(GitNFT {
            id: object::new(ctx),
            name: b"AnhQuan2004".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://i.pinimg.com/236x/f6/4a/4e/f64a4e6beb67c49f571cc78f8b95fe37--monsters-university-monsters-inc.jpg"),
            creator: ctx.sender()
        }, ctx.sender());
    }



}