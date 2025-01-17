/*
#[test_only]
module move_nft::move_nft_tests;
// uncomment this line to import the module
// use move_nft::move_nft;

const ENotImplemented: u64 = 0;

#[test]
fun test_move_nft() {
    // pass
}

#[test, expected_failure(abort_code = ::move_nft::move_nft_tests::ENotImplemented)]
fun test_move_nft_fail() {
    abort ENotImplemented
}
*/

#[test_only]
module move_nft::move_nft_tests;
// uncomment this line to import the module
use move_nft::move_nft::{mint, StructNFT};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use std::string;
use sui::url;

const GITHUB_ID: vector<u8> = b"longphu25";
const URL: vector<u8> = b"https://avatars.githubusercontent.com/longphu25";


#[test]
fun test_move_nft() {
    let alice = @0x1e0;
    let bob = @0x1e1;

    // Mint a nft to Bob by Alice
    let mut scenario = test_scenario::begin(alice);
    {
        mint(b"NFT", b"This is a Move NFT", bob, test_scenario::ctx(&mut scenario));    
    };

    // Check Bob's nft
    test_scenario::next_tx(&mut scenario, bob);
    {
        let nft = test_scenario::take_from_sender<StructNFT>(&scenario);
        let mut nft_name = GITHUB_ID.to_string();
        nft_name.append(b" ".to_string());
        nft_name.append(b"NFT".to_string());
        assert_eq(*nft.name(), nft_name);
        assert_eq(*nft.description(), string::utf8(b"This is a Move NFT"));
        assert_eq(*nft.url(), url::new_unsafe_from_bytes(URL));
        assert_eq(*nft.github_id(), string::utf8(GITHUB_ID));
        scenario.return_to_sender(nft);
    };

    test_scenario::end(scenario);
}
