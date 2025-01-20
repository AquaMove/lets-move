module task4::task4;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use sui::random::{Self, Random};
use my_coin::faucet_coin::FAUCET_COIN;

public struct Game has key {
    id: UID,
    balance: Balance<FAUCET_COIN>
}

public struct Admin has key {
    id: UID
}

fun init(ctx: &mut TxContext) {
    let game = Game {
        id: object::new(ctx),
        balance: balance::zero<FAUCET_COIN>()
    };

    transfer::share_object(game);

    let admin = Admin {id: object::new(ctx)};
    transfer::transfer(admin, ctx.sender());
}

entry fun deposit(game: &mut Game, token: &mut Coin<FAUCET_COIN>, amount: u64) {
    let split_balance = balance::split(coin::balance_mut(token), amount);
    balance::join<FAUCET_COIN>(&mut game.balance, split_balance);
}

entry fun withdraw(game: &mut Game, _: &Admin, amount: u64, ctx: &mut TxContext) {
    let cash = coin::take<FAUCET_COIN>(&mut game.balance, amount, ctx);
    transfer::public_transfer(cash, ctx.sender());
}

entry fun play(game: &mut Game, rnd: &Random, guess: bool, token: &mut Coin<FAUCET_COIN>, ctx: &mut TxContext) {
    let mut gen = random::new_generator(rnd, ctx);
    let flag = random::generate_bool(&mut gen);
    if (flag == guess) {
        let reward = coin::take<FAUCET_COIN>(&mut game.balance, 100_000_000, ctx);
        coin::join(token, reward);
    } else {
        deposit(game, token, 100_000_000);
    }
}
