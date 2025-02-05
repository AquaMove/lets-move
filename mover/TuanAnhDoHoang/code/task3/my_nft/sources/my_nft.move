/*
/// Module: my_nft
module my_nft::my_nft;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module my_nft::my_nft;
use sui::{
    object::{Self, UID},
    url::{Self, Url, new_unsafe_from_bytes},
    transfer,
    tx_context::{Self, TxContext},
};

use std::{
    string,
};
public struct NFT has key, store{
    id: UID,
    name: string::String, //Bau troi it sao
    url: Url, //https://avatars.githubusercontent.com/u/95602145?s=400&u=0199ea33cf70e9316f5865c3fc744def8a4fddf9&v=4
    link_image: Url, //https://avatars.githubusercontent.com/u/95602145?s=400&u=0199ea33cf70e9316f5865c3fc744def8a4fddf9&v=4
    description: string::String, //this is nft 
    author: string::String, //anhdoo
}

public fun mint_NFT(name: vector<u8>, url_: vector<u8>, link_image: vector<u8>, description: vector<u8>, author: vector<u8>, ctx:&mut TxContext){
    let nft_ = NFT{
        id: object::new(ctx),
        name: string::utf8(name),
        url: url::new_unsafe_from_bytes(url_),
        link_image: new_unsafe_from_bytes(link_image),
        description: string::utf8(description),
        author: string::utf8(author),
    };
    transfer::public_transfer(nft_,ctx.sender());
}
public fun send_nft(nft_: NFT, recipient: address, ctx: &mut TxContext){
    transfer::public_transfer(nft_, recipient);
}

// #[test_only]
// use sui::test_scenario as tx;
// const ALICE: address =  @0x123214;


// #[test]
// public fun transfer_to_address(){
//     tx::begin(){
//         send_nft(nft_, recipient, ctx)
//     }
    
// }
