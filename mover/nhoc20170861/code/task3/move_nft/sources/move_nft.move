/*
/// Module: move_nft
module move_nft::move_nft;
Author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module move_nft::move_nft {
    use sui::url::{Self, Url};
    use std::string::{Self, String};

    const AVATAR_URL: vector<u8> = b"https://s2.coinmarketcap.com/static/img/coins/200x200/20947.png";

    public struct Nft has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    public entry fun mint( description: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let move_nft = Nft {
            id: object::new(ctx),
            name: b"nhoc20170861".to_string(),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(AVATAR_URL),
        };

        transfer::public_transfer(move_nft, recipient);
    }
}