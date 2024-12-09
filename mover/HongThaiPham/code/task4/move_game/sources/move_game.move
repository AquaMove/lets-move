/*
/// Module: move_game
module move_game::move_game;
*/


module move_game::onetwothree {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::random::{Self, new_generator, Random};
    use faucet_coin::faucet_coin::{FAUCET_COIN};



    const EInvalidAmount: u64 = 0;
    const EUnauthorized: u64 = 1;

    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>,
        bot: Option<u8>,
        lasted_player_choice: Option<u8>,
        winner: Option<address>
    }
    
    fun init(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero(),
            bot: option::none(),
            lasted_player_choice: option::none(),
            winner: option::none()
        };
        transfer::public_share_object(game);
    }

    public entry fun new_game(payment: Coin<FAUCET_COIN>, ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: coin::into_balance(payment),
            bot: option::none(),
            lasted_player_choice: option::none(),
            winner: option::none()
        };
        transfer::transfer(game, tx_context::sender(ctx));
    }

    
    entry fun play(r: &Random, game: &mut Game, payment: Coin<FAUCET_COIN>, player_choice: u8, ctx: &mut TxContext) {
        assert!(payment.value() > 0, EInvalidAmount);
        // let value = coin::value(&payment);
        coin::put(&mut game.balance, payment);

        let mut generator = new_generator(r, ctx); // generator is a PRG
        let bot = random::generate_u8_in_range(&mut generator, 1, 15);

        if (player_choice == bot) {
            // player win
            game.winner = option::some(tx_context::sender(ctx));
        } ;
        game.bot = option::some(bot);
        game.lasted_player_choice = option::some(player_choice);
    }

    public entry fun take_reward(game: Game, ctx: &mut TxContext) {
        assert!(option::borrow(&game.winner) == &tx_context::sender(ctx), EUnauthorized);
        let Game { id, balance,  bot:_, lasted_player_choice:_, winner:_} = game;
        let payment = coin::from_balance(balance, ctx);
        transfer::public_transfer(payment, tx_context::sender(ctx));
        object::delete(id);
    }


    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx);
    }

    #[test_only]
    public fun get_game_balance(game: &Game) : u64 {
        game.balance.value()
    }
}