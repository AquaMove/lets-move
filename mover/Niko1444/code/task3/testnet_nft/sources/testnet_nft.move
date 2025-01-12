/*
/// Module: testnet_nft
module testnet_nft::testnet_nft;
*/

module 0x0::testnet_nft {

    use std::string::{String};
    use sui::url::{Self, Url};

    public struct GitNFT has key, store{
        id: UID,
        name: String,
        image_url: Url,
        creator: address
    }

    // init function

    fun init(ctx: &mut TxContext){

        let obj = GitNFT {
            id: object::new(ctx),
            name: b"Niko1444".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/91601109?s=400&u=a7a4c4ba52e93bc91e09516d459818497df5f359&v=4"),
            creator: ctx.sender()
        };

        transfer::transfer(obj, ctx.sender());

    }

    public entry fun mint(ctx: &mut TxContext){
        transfer::transfer(GitNFT{ 
             id: object::new(ctx),
            name: b"Niko1444".to_string(),
            image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/91601109?s=400&u=a7a4c4ba52e93bc91e09516d459818497df5f359&v=4"),
            creator: ctx.sender()
        }, ctx.sender())
    }

    public entry fun transfer_nft(nft: GitNFT, recipient: address){
        transfer::transfer(nft, recipient);
    }
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


