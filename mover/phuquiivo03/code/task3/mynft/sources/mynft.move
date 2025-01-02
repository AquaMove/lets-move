module mynft::nft {
    use std::string::{String, utf8};
 use sui::url::{Self, Url};
    public struct MyNFT has key {
        id: UID,
        name: String,
        description: String,
        url: Url

    }
        fun init(ctx: &mut TxContext) {
            let nft = MyNFT {
                id: object::new(ctx),
                name: utf8(b"Phuquiivo03"),
                description: utf8(b"Aydo, Phuquitoichoi!"),
                url: url::new_unsafe_from_bytes(b"https://img.notionusercontent.com/s3/prod-files-secure%2Fdf0f4344-aa59-48dc-938b-a5736604ea95%2Fe3fed5bd-f2b3-49ba-b3ad-b96f8f2b23f1%2Fnotion-avatar-1723093607415.png/size/w=720?exp=1735710575&sig=sJmk0mUbqYZPdgJAO24HOsxHYF2azNu3N60Z-5A48Qs"),
            };
            transfer::transfer(nft, @0x76d033c1a779f9a7984825a08ba632e97eba6954b1242cd7d87a4c0e261b1f25);

        }

}