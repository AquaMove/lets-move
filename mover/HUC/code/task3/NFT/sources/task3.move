/*
/// Module: task3
module task3::task3;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module 0x0::NFT {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    
    public struct GitNFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
        creator: address
    }

    fun init(ctx: &mut TxContext) {
        let obj = GitNFT {
            id: object::new(ctx),
            name: string::utf8(b"PINK PANTHER"),
            description: string::utf8(b"The Pink Panther is a cartoon character"),
            image_url: url::new_unsafe_from_bytes(b"https://www.google.com/imgres?q=b%C3%A1o%20h%E1%BB%93ng&imgurl=https%3A%2F%2Ftophinhanh.net%2Fwp-content%2Fuploads%2F2024%2F03%2Fhinh-nen-bao-hong-18.jpg&imgrefurl=https%3A%2F%2Ftophinhanh.net%2Fhinh-nen-bao-hong%2F&docid=VSUCugqO4r2-rM&tbnid=iINizOYT9o370M&vet=12ahUKEwjG0r60vciKAxU78DQHHZXUJWIQM3oECEAQAA..i&w=600&h=1298&hcb=2&ved=2ahUKEwjG0r60vciKAxU78DQHHZXUJWIQM3oECEAQAA"),
            creator: tx_context::sender(ctx)
        };

        transfer::transfer(obj, tx_context::sender(ctx));
    }

    public entry fun mint(ctx: &mut TxContext) {
            let obj = GitNFT {
                id: object::new(ctx),
                name: string::utf8(b"PINK PANTHER"),
                description: string::utf8(b"he Pink Panther is a cartoon character"),
                image_url: url::new_unsafe_from_bytes(b"https://tophinhanh.net/wp-content/uploads/2024/03/hinh-nen-bao-hong-18.jpg"),
                creator: ctx.sender()
            };
        transfer::transfer(obj, ctx.sender());
    }
}