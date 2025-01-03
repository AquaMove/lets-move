/*
/// Module: move_game
module move_game::move_game;
Author: nhoc20170861
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module move_game::move_game {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

    use faucet_coin::faucet_coin::FAUCET_COIN;

    const REWARD: u64 = 1_000_000_000;

    public struct Game has key, store {
        id: UID,
        balance: Balance<FAUCET_COIN>
    }

    public struct Admin has key, store {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(Game {
                id: object::new(ctx),
                balance: balance::zero<FAUCET_COIN>()
            }
        );

        transfer::public_transfer(Admin {
            id: object::new(ctx)
        }, ctx.sender());
    }

    /// The `deposit` function adds a specified amount of `FAUCET_COIN` to the game's balance.
    /// It takes a mutable reference to the game, a mutable reference to the coin to deposit from,
    /// and the amount to deposit. The function splits the specified amount from the coin's balance
    /// and then adds it to the game's balance.
    entry fun deposit(
        move_game: &mut Game,
        coin: &mut Coin<FAUCET_COIN>,
        amount: u64
    ) {
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        balance::join(&mut move_game.balance, split_balance);
    }

    entry fun withdraw(
        move_game: &mut Game,
        _: &Admin,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let withdraw_coin = coin::take(&mut move_game.balance, amount, ctx);
        transfer::public_transfer(withdraw_coin, ctx.sender());
    }

    entry fun play(
        move_game: &mut Game,
        rnd: &Random,
        guess: bool,
        coin: &mut Coin<FAUCET_COIN>,
        ctx: &mut TxContext
    ) {
        let mut random_generator = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut random_generator);
        
        // flag is a random boolean value
        // if the user's guess matches the flag, they win the reward
        // otherwise, the reward is added to the game's balance
        if (flag == guess) {
            let reward = coin::take(&mut move_game.balance, REWARD, ctx);
            coin::join(coin, reward); // reward is added to the user's coin
        } else {
            deposit(move_game, coin, REWARD); // reward is added to the game's balance
        }
    }

}