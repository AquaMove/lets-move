module move_nft::move_nft {
    use std::string;
    use sui::url::{Self, Url};
    use sui::transfer;

    public struct TestnetNFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
    }

    #[allow(lint(self_transfer))]
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext,
    ) {
        let sender = ctx.sender();
        let nft = TestnetNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url),
        };
      
        transfer::public_transfer(nft, sender);
    }

    public fun name(nft: &TestnetNFT): &string::String {
        &nft.name
    }

    public entry fun transfer_nft(
        nft: TestnetNFT,
        recipient: address,
    ) {
        transfer::transfer(nft, recipient);
    }


}
