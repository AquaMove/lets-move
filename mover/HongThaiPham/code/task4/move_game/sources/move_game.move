/*
/// Module: move_game
module move_game::move_game;
*/


module move_game::onetwothree {
    use sui::coin::{Self, Coin};
    const EInvalidAmount: u64 = 0;
    public entry fun play<T>(coin: Coin<T>, _ctx: &mut TxContext) {
        assert!(coin.value() > 0, EInvalidAmount);
    }
}