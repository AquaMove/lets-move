module 0x0::my_coin {
    use sui::coin::{TreasuryCap ,Self , Coin };
    use sui::tx_context::{Self,TxContext};

    //Otw
    public struct MY_COIN has drop {}

    fun init (witness: MY_COIN , ctx : &mut TxContext){
        let(treasury , coinmetadata) = coin::create_currency(
            witness,
            5 , 
            b"Coin's Mortal", 
            b"Adias_thuong_hieu_cua_toi" ,
            b"Dong_coin_nay_rat_hiem",
            option::none(), 
            ctx);
            transfer::public_freeze_object(coinmetadata); // đóng băng ojb coin này không thể chuyển nhượng nữanữa
            transfer::public_transfer(treasury, ctx.sender()); // công khai obj coin này
            
    }
    public entry fun mint_token( treasury : &mut TreasuryCap<MY_COIN> ,ctx :   &mut TxContext ){
        let coin_object = coin::mint(treasury, 350000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}