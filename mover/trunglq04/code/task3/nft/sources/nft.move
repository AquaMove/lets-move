module 0x0::task3 {
    
    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct LouisNFT has key, store {
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    fun init(ctx: &mut TxContext) {
        
        let obj = LouisNFT {
            id: object::new(ctx),
            name: b"louisdemafia".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg"),
            creator: ctx.sender(),
        };

        transfer::transfer(obj, ctx.sender())
    }
    
    public entry fun mint(ctx: &mut TxContext) {
        transfer::transfer(LouisNFT {
            id: object::new(ctx),
            name: b"louisdemafia".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg"),
            creator: @0xbc5049e7435b74e526e13346cbb169a6ab6a6bd3393b1f2bde632dd5c69c2dbc,
        }, ctx.sender());
    }
}