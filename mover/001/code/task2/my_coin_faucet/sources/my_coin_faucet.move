module 0x0::my_coin_faucet {
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::tx_context::TxContext;
    use sui::transfer;

    // Đúng quy tắc của "One-time witness type" - trùng với module name
    public struct MY_COIN_FAUCET has drop {}

    fun init(witness: MY_COIN_FAUCET, ctx: &mut TxContext) {
        let (treasury, coinmetadata) = coin::create_currency(
            witness,
            5,  // decimals
            b"AQ",  // symbol
            b"AnhQuan2004 Coin",  // name
            b"AnhQuan2004 Coin",  // description
            std::option::none(),  // icon URL
            ctx
        );

        transfer::public_freeze_object(coinmetadata);
        transfer::public_share_object(treasury); // Chia sẻ TreasuryCap
    }

    // Mint từ TreasuryCap đã chia sẻ
    public entry fun mint_token(treasury: &mut TreasuryCap<MY_COIN_FAUCET>, ctx: &mut TxContext) {
        let coin_object: Coin<MY_COIN_FAUCET> = coin::mint(treasury, 350000, ctx);
        transfer::public_transfer(coin_object, ctx.sender());
    }
}
