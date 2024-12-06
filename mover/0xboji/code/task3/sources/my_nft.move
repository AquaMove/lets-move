module task3::boji_nft {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{Self, String};

    // >>>>>>>>>> Start Constants <<<<<<<<<<
    const NFT_IMAGE_URL: vector<u8> = b"https://aggregator.walrus-testnet.walrus.space/v1/leKx-CMcdhLBrWq8bN74-2K6uSzRIXtswM4felFFUl8";
    // >>>>>>>>>> End Constants <<<<<<<<<<

    // >>>>>>>>>> Start Structs <<<<<<<<<<
    public struct BojiNFT has key, store {
        id: UID,
        name: String,
        image_url: String,
    }
    // >>>>>>>>>> End Structs <<<<<<<<<<
    // >>>>>>>>>> Start Witness Types <<<<<<<<<<
    public struct BOJI_NFT has drop {}
    // >>>>>>>>>> End Witness Types <<<<<<<<<<

    // >>>>>>>>>> Start INIT Functions <<<<<<<<<<
    fun init(witness: BOJI_NFT, ctx: &mut TxContext) {
        let publisher = package::claim(witness, ctx);
        let mut display = display::new_with_fields<BojiNFT>(
            &publisher, 
            vector[
                string::utf8(b"name"),
                string::utf8(b"image_url"),
                string::utf8(b"description"),
                string::utf8(b"project_url"),
                string::utf8(b"creator"),
            ],
            vector[
                string::utf8(b"{name}"),
                string::utf8(b"{image_url}"),
                string::utf8(b"A unique NFT created by Boji"),
                string::utf8(b"https://github.com/0xBoji"),
                string::utf8(b"Boji"),
            ],
            ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }
    // >>>>>>>>>> End INIT Functions <<<<<<<<<<

    // >>>>>>>>>> Start Public Functions <<<<<<<<<<
    public entry fun mint(
        name: vector<u8>,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let nft = BojiNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            image_url: string::utf8(NFT_IMAGE_URL),
        };

        transfer::public_transfer(nft, recipient);
    }

    public entry fun transfer_nft(
        nft: BojiNFT,
        recipient: address,
    ) {
        transfer::public_transfer(nft, recipient);
    }
    // >>>>>>>>>> End Public Functions <<<<<<<<<<

    // >>>>>>>>>> Start Getters <<<<<<<<<<
    public fun name(nft: &BojiNFT): &String {
        &nft.name
    }

    public fun image_url(nft: &BojiNFT): &String {
        &nft.image_url
    }
    
    #[test_only]
    public fun mint_for_testing(
        name: vector<u8>,
        ctx: &mut TxContext
    ): BojiNFT {
        BojiNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            image_url: string::utf8(NFT_IMAGE_URL),
        }
    }
}