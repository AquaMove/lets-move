module faucet_coin::faucet_coin{
    use sui::coin::{Self, TreasuryCap};
    use sui::url;
    
    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let(treasury, coinmetada) = coin::create_currency<FAUCET_COIN>(
            witness, 
            5, 
            b"FAUCET", 
            b"FAUCET COIN", 
            b"MY_FIRST_COIN", 
            option::some(url::new_unsafe_from_bytes(b"https://avatars.githubusercontent.com/u/82193701?v=4")), 
            ctx
        );
        transfer::public_freeze_object(coinmetada);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_token(treasury: &mut TreasuryCap<FAUCET_COIN>, ctx: &mut TxContext) {
       let coin_object = coin::mint(treasury, 10000000, ctx);
       transfer::public_transfer(coin_object, ctx.sender());
    }
    
    #[test_only]
    use sui::coin::Coin;

    #[test_only]
    public fun mint_for_testing(value: u64, ctx: &mut TxContext): Coin<MY_COIN> {
        coin::mint_for_testing<MY_COIN>(value, ctx)
    }
}