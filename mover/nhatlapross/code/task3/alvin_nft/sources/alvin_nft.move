/*
/// Module: alvin_nft
module alvin_nft::alvin_nft;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module 0x0::alvin_nft{
    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct ALVIN_NFT has key,store{
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    //init
    fun init(ctx: &mut TxContext){
        let obj = ALVIN_NFT{
            id: object::new(ctx),
            name: b"Alvin Ichi developer".to_string(),
            image_url: url::new_unsafe(std::ascii::string(b"https://coffee-teenage-wolf-435.mypinata.cloud/ipfs/QmebHnFqnGJRsrwFwcThvPUdt699dtWhhyqTigi9JSfsNa")),
            creator: ctx.sender()
        };
        transfer::transfer(obj, ctx.sender())
    }

    public entry fun mint(ctx: &mut TxContext){
        transfer::transfer(ALVIN_NFT{
            id: object::new(ctx),
            name: b"Alvin Ichi developer".to_string(),
            image_url: url::new_unsafe(std::ascii::string(b"https://coffee-teenage-wolf-435.mypinata.cloud/ipfs/QmebHnFqnGJRsrwFwcThvPUdt699dtWhhyqTigi9JSfsNa")),
            creator: ctx.sender()
        }, ctx.sender())
    }
}