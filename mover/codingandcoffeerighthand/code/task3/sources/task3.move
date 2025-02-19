module task3::task3;

use std::string::String;
use sui::url::{Self, Url};

public struct CodingandcoffeerighthandNFT has key, store {
    id: UID,
    name: String,
    image_url: Url,
    creator: address,
}

public entry fun mint(ctx: &mut TxContext) {
    let obj = CodingandcoffeerighthandNFT {
        id: object::new(ctx),
        name: b"codingandcoffeerighthand".to_string(),
        image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/105044388"),
        creator: ctx.sender(),
    };
    transfer::public_transfer(obj, ctx.sender())
}
