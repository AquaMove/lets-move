/*
/// Module: move_game
module move_game::move_game;
*/


module move_game::hongthaipham {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::random::{Self, new_generator, Random};
    use faucet_coin::faucet_coin::{FAUCET_COIN};
    use std::string::{Self, String};
    use std::debug;

    const EInvalidAmount: u64 = 0;
    const EUnauthorized: u64 = 1;
    const EGameIsOver: u64 = 2;
    const EGameIsNotOver: u64 = 3;

    const MIN_RANDOM: u8 = 1;
    const MAX_RANDOM: u8 = 7;

    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>, // keep track of the balance of the game
        even_win: bool, // if true, the player wins when sum of player_choice and bot is even and vice versa
        bot: Option<u8>, // the bot's choice
        player_choice: Option<u8>, // the lasted player's choice
        lasted_player: Option<address>, // the lasted player
        github_id: String,
    }
    


    public entry fun new_game(payment: Coin<FAUCET_COIN>, even_win: bool, ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: coin::into_balance(payment),
            even_win,
            bot: option::none(),
            player_choice: option::none(),
            lasted_player: option::none(),
            github_id: string::utf8(b"hongthaipham"),
        };
        transfer::transfer(game, tx_context::sender(ctx));
    }

    #[allow(lint(public_random))]
    public entry fun play(r: &Random, game: &mut Game, payment: Coin<FAUCET_COIN>, player_choice: u8, ctx: &mut TxContext) {
        // check if user deposit coin to play
        assert!(payment.value() > 0, EInvalidAmount);
        // check if the game is over

        assert!(!game_is_over(game), EGameIsOver);
        coin::put(&mut game.balance, payment);

        let mut generator = new_generator(r, ctx); // generator is a PRG
        let bot = random::generate_u8_in_range(&mut generator, MIN_RANDOM, MAX_RANDOM);
        debug::print(&bot);
        game.bot = option::some(bot);
        game.player_choice = option::some(player_choice);
        game.lasted_player = option::some(tx_context::sender(ctx));
    }

    public entry fun take_reward(game: Game, ctx: &mut TxContext) {
        assert!(game_is_over(&game), EGameIsNotOver);
        assert!(option::borrow(&game.lasted_player) == &tx_context::sender(ctx), EUnauthorized);
        let Game { id, balance, even_win:_,  bot:_, lasted_player:_, player_choice:_, github_id:_} = game;
        let payment = coin::from_balance(balance, ctx);
        transfer::public_transfer(payment, tx_context::sender(ctx));
        object::delete(id);
    }

    fun game_is_over(game: &Game) : bool {  
        game.bot.is_some() && game.player_choice.is_some() && ((*option::borrow(&game.player_choice) + *option::borrow(&game.bot)) % 2 == 0) == game.even_win
    }


    public fun get_game_balance(game: &Game) : u64 {
        game.balance.value()
    }

    public fun get_game_bot(game: &Game) : u8 {
        *option::borrow(&game.bot)
    }

    public fun get_game_player_choice(game: &Game) : u8 {
        *option::borrow(&game.player_choice)
    }

    public fun get_game_lasted_player(game: &Game) : address {
        *option::borrow(&game.lasted_player)
    }

    public fun get_game_even_win(game: &Game) : bool {
        game.even_win
    }

     #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero(),
            even_win: false,
            bot: option::none(),
            player_choice: option::none(),
            lasted_player: option::none(),
            github_id: string::utf8(b"hongthaipham"),
        };
        transfer::transfer(game, tx_context::sender(ctx));
    }
}