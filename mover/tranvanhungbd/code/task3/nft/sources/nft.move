module 0x0::task3{

    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct TranvanhungbdNFT has key, store {  
        id: UID,
        name: String,
        img_url: Url,
        creator: address,
    }

    fun init(ctx: &mut TxContext) {
        let nft_obj = TranvanhungbdNFT {
            id: object::new(ctx),
            name: b"TranvanhungbdNFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/198184038?v=4"),
            creator: ctx.sender()
        };
        transfer::transfer(nft_obj,ctx.sender());
    }

    public entry fun mint_nft(ctx: &mut TxContext) {
        transfer::transfer( TranvanhungbdNFT {
            id: object::new(ctx),
            name: b"TranvanhungbdNFT".to_string(),
            img_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/198184038?v=4"),
            creator: ctx.sender() 
        }, ctx.sender())
    }

     public entry fun transfer_nft(
        nft: TranvanhungbdNFT, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        transfer::transfer(nft, recipient);
    }
}
