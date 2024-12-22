module task3::knave {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

public struct KNAVE has key, store {
    id: UID,
    name: string::String,
    description: string::String,
    url: Url
}
public entry fun mint(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    ctx: &mut TxContext
) {
   
 
    let nft = KNAVE {
        id: object::new(ctx),
        name: string::utf8(name),
        description: description.to_string(),
        url: url::new_unsafe_from_bytes(url)
    };
 
    transfer::public_transfer(nft, ctx.sender());
}   
}