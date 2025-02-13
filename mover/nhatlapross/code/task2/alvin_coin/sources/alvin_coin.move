/*
/// Module: alvin_coin
module alvin_coin::alvin_coin;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module 0x0::alvin_coin{
    use sui::coin::{Self,TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::url;
    public struct ALVIN_COIN has drop {}

    fun init(witness: ALVIN_COIN,ctx: &mut TxContext) {
        let ascii_url = std::ascii::string(b"https://coffee-teenage-wolf-435.mypinata.cloud/ipfs/QmTkTRCQpPVRwibQ1DeTF9JLyEkQmgL1rjsAS8XE6nFEMi");
        let icon_url = url::new_unsafe(ascii_url);
        let icon_url_option = option::some(icon_url);
        let(treasury, coinmetadata) = coin::create_currency(witness,
        5,
        b"ALC",
        b"Alvin Coin",
        b"My first coin",
        icon_url_option,
        ctx);

        transfer::public_freeze_object(coinmetadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<ALVIN_COIN>,ctx: &mut TxContext) {
        let coin_object = coin::mint(treasury,350000,ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}