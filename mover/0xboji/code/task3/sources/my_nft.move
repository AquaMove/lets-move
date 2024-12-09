module task3::boji_nft {
    // >>>>>>>>>> Start Imports <<<<<<<<<<
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{Self, String};
    // >>>>>>>>>> End Imports <<<<<<<<<<

    // >>>>>>>>>> Start Structs <<<<<<<<<<
    /// The NFT struct
    struct BojiNFT has key, store {
        id: UID,
        name: String,
        image_url: String,
    }

    struct BOJI_NFT has drop {}
    // >>>>>>>>>> End Structs <<<<<<<<<<

    // >>>>>>>>>> Start INIT Functions <<<<<<<<<<
    /// Module initializer
    fun init(witness: BOJI_NFT, ctx: &mut TxContext) {
        let keys = vector[
            string::utf8(b"name"),
            string::utf8(b"image_url"),
            string::utf8(b"description"),
            string::utf8(b"project_url"),
            string::utf8(b"creator"),
        ];

        let values = vector[
            string::utf8(b"{name}"),
            string::utf8(b"https://aggregator.walrus-testnet.walrus.space/v1/leKx-CMcdhLBrWq8bN74-2K6uSzRIXtswM4felFFUl8"),
            string::utf8(b"A unique NFT created by Boji"),
            string::utf8(b"https://github.com/0xBoji"),
            string::utf8(b"Boji"),
        ];

        // Claim the Publisher object
        let publisher = package::claim(witness, ctx);

        // Create the Display object
        let display = display::new_with_fields<BojiNFT>(
            &publisher, 
            keys, 
            values, 
            ctx
        );

        // Update display version
        display::update_version(&mut display);

        // Transfer Publisher and Display objects to sender
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
            image_url: string::utf8(b"https://aggregator.walrus-testnet.walrus.space/v1/leKx-CMcdhLBrWq8bN74-2K6uSzRIXtswM4felFFUl8"),
        };

        transfer::public_transfer(nft, recipient);
    }

    /// Transfer an NFT to a recipient
    public entry fun transfer_nft(
        nft: BojiNFT,
        recipient: address,
    ) {
        transfer::public_transfer(nft, recipient);
    }

    // Getters
    public fun name(nft: &BojiNFT): &String {
        &nft.name
    }

    public fun image_url(nft: &BojiNFT): &String {
        &nft.image_url
    }
    // >>>>>>>>>> End Public Functions <<<<<<<<<<
}