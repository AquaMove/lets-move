/*
/// Module: move_game
module move_game::move_game;
*/
module move_game::move_game {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::clock::{Self, Clock};
    use sui::event;

    // Error codes
    const EInsufficientBalance: u64 = 0;
    const EInvalidBetAmount: u64 = 1;

    const MIN_BET: u64 = 100;

    public struct GameHouse has key {
        id: UID,
        balance: Balance<sui::sui::SUI>,
        games_played: u64
    }

    public struct WinEvent has copy, drop {
        player: address,
        amount: u64
    }

    public struct LoseEvent has copy, drop {
        player: address,
        amount: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            GameHouse {
                id: object::new(ctx),
                balance: balance::zero(),
                games_played: 0
            }
        );
    }

    public entry fun fund_house(
        house: &mut GameHouse, 
        coin: Coin<sui::sui::SUI>
    ) {
        let balance = coin::into_balance(coin);
        balance::join(&mut house.balance, balance);
    }

    public entry fun withdraw(
        house: &mut GameHouse,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let withdrawal = coin::from_balance(
            balance::split(&mut house.balance, amount),
            ctx
        );
        transfer::public_transfer(withdrawal, tx_context::sender(ctx));
    }

    public entry fun play(
        house: &mut GameHouse,
        clock: &Clock,
        bet: Coin<sui::sui::SUI>,
        ctx: &mut TxContext
    ) {
        let bet_amount = coin::value(&bet);
        assert!(bet_amount >= MIN_BET, EInvalidBetAmount);

        // Generate random using timestamp
        let timestamp = clock::timestamp_ms(clock);
        let random = timestamp % 2;
        
        if (random == 1) {
            // Player wins
            let win_amount = bet_amount * 2;
            let prize = coin::from_balance(
                balance::split(&mut house.balance, win_amount),
                ctx
            );
            transfer::public_transfer(prize, tx_context::sender(ctx));
            event::emit(WinEvent {
                player: tx_context::sender(ctx),
                amount: win_amount
            });
            coin::destroy_zero(bet);
        } else {
            // House wins
            balance::join(&mut house.balance, coin::into_balance(bet));
            event::emit(LoseEvent {
                player: tx_context::sender(ctx),
                amount: bet_amount
            });
        };

        house.games_played = house.games_played + 1;
    }

    public fun house_balance(house: &GameHouse): u64 {
        balance::value(&house.balance)
    }

    public fun games_played(house: &GameHouse): u64 {
        house.games_played
    }
}