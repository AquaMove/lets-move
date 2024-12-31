// module task3::NFT;

// use sui::url::{Self, Url};
// use std::string;

// public struct TuanO20_NFT has key, store {
//     id: UID,
//     name: string::String,
//     description: string::String,
//     url: Url,
//     creator: address,
// }

// #[allow(lint(self_transfer))]
// public entry fun mint(ctx: &mut TxContext, name: vector<u8>, description: vector<u8>, url: vector<u8>) {
//     let nft = TuanO20_NFT {
//         id: object::new(ctx),
//         name: string::utf8(name),
//         description: string::utf8(description),
//         url: url::new_unsafe_from_bytes(url),
//         creator: ctx.sender(),
//     };

//     transfer::public_transfer(nft, ctx.sender());
// }

module task3::NFT;

use sui::url::{Self, Url};
use std::string;

public struct TuanO20_NFT has key, store {
    id: UID,
    name: string::String,
    description: string::String,
    url: Url,
    creator: address,
}

#[allow(lint(self_transfer))]
public entry fun mint(ctx: &mut TxContext) {
    let nft = TuanO20_NFT {
        id: object::new(ctx),
        name: b"TuanO20 NFT".to_string(),
        description: b"This NFT is created by Tran Anh Tuan in Sui Hackcamp 2024".to_string(),
        url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/89649508?v=4"),
        creator: ctx.sender(),
    };

    transfer::public_transfer(nft, ctx.sender());
}



