module task4::task4;

use faucet_coin::faucet_coin::FAUCET_COIN;
use std::string::String;
use sui::balance;
use sui::coin;
use sui::event;
use sui::random;

public struct Game has key {
    id: UID,
    balance: balance::Balance<FAUCET_COIN>,
}

public struct GameEvent has copy, drop {
    id: ID,
    is_win: bool,
    author: String,
}

public struct Admin has key {
    id: UID,
}

fun init(ctx: &mut TxContext) {
    transfer::share_object(Game {
        id: object::new(ctx),
        balance: balance::zero<FAUCET_COIN>(),
    });

    transfer::transfer(
        Admin {
            id: object::new(ctx),
        },
        ctx.sender(),
    );
}

entry fun deposit(game: &mut Game, coin: &mut coin::Coin<FAUCET_COIN>, amount: u64) {
    let split_balance = balance::split(coin::balance_mut(coin), amount);
    balance::join(&mut game.balance, split_balance);
}

entry fun withdraw(game: &mut Game, _: &Admin, amount: u64, ctx: &mut TxContext) {
    let cash = coin::take(&mut game.balance, amount, ctx);
    transfer::public_transfer(cash, ctx.sender());
}

entry fun play(
    game: &mut Game,
    rnd: &random::Random,
    guess: bool,
    coin: &mut coin::Coin<FAUCET_COIN>,
    ctx: &mut TxContext,
) {
    let mut gen = random::new_generator(rnd, ctx);
    let flag = random::generate_bool(&mut gen);
    let id = *object::uid_as_inner(&game.id);
    if (flag == guess) {
        let reward = coin::take(&mut game.balance, 1_000_000, ctx);
        coin::join(coin, reward);
        event::emit(GameEvent {
            id: id,
            is_win: true,
            author: b"codingandcoffeerighthand".to_string(),
        });
    } else {
        deposit(game, coin, 1_000_000);
        event::emit(GameEvent {
            id: id,
            is_win: false,
            author: b"codingandcoffeerighthand".to_string(),
        });
    }
}
