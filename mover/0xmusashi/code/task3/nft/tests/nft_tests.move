#[test_only]
module nft::nft_tests;
use nft::nft::{mint, Nft};
use sui::test_scenario;
use sui::test_utils::{assert_eq};
use std::string;
use sui::url;

const AVATAR_URL: vector<u8> = b"https://avatars.githubusercontent.com/0xmusashi";

#[test]
fun test_nft() {
    let alice = @0x1e0;
    let bob = @0x1e1;

    // Mint a nft to Bob by Alice
    let mut scenario = test_scenario::begin(alice);
    {
        mint(b"NFT", b"Test NFT", bob, test_scenario::ctx(&mut scenario));    
    };

    // Check Bob's nft
    test_scenario::next_tx(&mut scenario, bob);
    {
        let nft = test_scenario::take_from_sender<Nft>(&scenario);
        assert_eq(*nft.name(), b"NFT".to_string());
        assert_eq(*nft.description(), string::utf8(b"Test NFT"));
        assert_eq(*nft.url(), url::new_unsafe_from_bytes(AVATAR_URL));
        scenario.return_to_sender(nft);
    };

    test_scenario::end(scenario);
}