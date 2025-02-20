module 0x0::my_coin {

    use sui::coin::{Self, TreasuryCap};

    // One time witness
    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness, 
            2, 
            b"LOUIS",
            b"Louis coin",
            b"My coin for task 2", 
            option::none(), 
            ctx);

            transfer::public_freeze_object(coinmetadata);
            transfer::public_share_object(treasury);
    }

    public entry fun mint(treasury: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) 
    {
        coin::mint_and_transfer(treasury, amount, recipient, ctx);
    }
}