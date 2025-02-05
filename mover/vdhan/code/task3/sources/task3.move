module task3::task3;
use std::string::String;
use sui::url::{Self, Url};

public struct AnNFT has key, store {
    id: UID,
    name: String,
    image_url: Url,
    creator: address
}

fun init(ctx: &mut TxContext) {
    let obj = AnNFT {
        id: object::new(ctx),
        name: b"Vũ Đắc Hoàng Ân".to_string(),
        image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/3064758"),
        creator: ctx.sender()
    };

    transfer::transfer(obj, ctx.sender());
}

entry fun mint(ctx: &mut TxContext) {
    let obj = AnNFT {
        id: object::new(ctx),
        name: b"Vũ Đắc Hoàng Ân".to_string(),
        image_url: url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/3064758"),
        creator: ctx.sender()
    };

    transfer::transfer(obj, ctx.sender());
}
