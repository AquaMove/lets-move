module 0x0::my_coin {

    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};

    // One time witness
    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness, 
            8, 
            b"LOUIS",
            b"Louis coin",
            b"My coin for task 2", 
            option::none(), 
            ctx);

            // Object cannot be edited, deleted.
            transfer::public_freeze_object(coinmetadata);
            // Transfer of authority, allow everyone could have this object (token)
            // transfer::public_transfer(treasury, ctx.sender()
            transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN>, ctx: &mut TxContext) {
        // faucet with fixed amount
        let coin_object = coin::mint(treasury, 282828, ctx);
        transfer::public_transfer(coin_object, @0x06c3f585b8647bead4fb9379be37fc17c8d8e21542b9ccb8a85a4a46bb23c4d1);
    }
}