module faucet_coin::faucet_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    // OTW
    public struct FAUCET_COIN has drop {}


    
    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
    let ascii_url = std::ascii::string(b"https://coffee-teenage-wolf-435.mypinata.cloud/ipfs/QmTkTRCQpPVRwibQ1DeTF9JLyEkQmgL1rjsAS8XE6nFEMi");
    let icon_url = url::new_unsafe(ascii_url);
    let icon_url_option = option::some(icon_url);
    let (treasury, coinmetadata) = coin::create_currency(witness, 
     6, 
     b"ALC", 
     b"Alvin Coin", 
     b"Alvin faucet coin", 
     icon_url_option, 
     ctx);

     transfer::public_freeze_object(coinmetadata);
     transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury, 500000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}