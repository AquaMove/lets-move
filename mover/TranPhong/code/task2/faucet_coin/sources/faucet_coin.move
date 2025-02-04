module 0x0::faucet_coin {
    use sui::coin::{TreasuryCap ,Self };
    // use sui::tx_context::{Self,TxContext};

    //Otw
    public struct FAUCET_COIN has drop  {}
    fun init (witness: FAUCET_COIN , ctx : &mut TxContext){
        let(treasury , coinmetadata) = coin::create_currency(
            witness,
            5 , 
            b"Coin faucet", 
            b"pet's",
            b"idea",
            option::none(), 
            ctx);
            transfer::public_freeze_object(coinmetadata); // đóng băng ojb coin này không thể chuyển nhượng nữanữa
            transfer::public_share_object(treasury);
    }
    public entry fun mint_token( treasury : &mut TreasuryCap<FAUCET_COIN> ,ctx :   &mut TxContext ){
        let coin_object = coin::mint(treasury, 350000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}