module task4::GuessGame;

use faucet_coin::faucet_coin::{FAUCET_COIN};

use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use sui::random::{Self, Random};

const EInsufficientFund: u64 = 1;

public struct Game has key {
    id: UID,
    balance: Balance<FAUCET_COIN>
}

public struct AdminCap has key {
    id: UID
}

fun init(ctx: &mut TxContext) {
    let game = Game {
        id: object::new(ctx),
        balance: balance::zero<FAUCET_COIN>()
    };
    transfer::share_object(game);

    let admin = AdminCap {
        id: object::new(ctx)
    };
    transfer::transfer(admin, ctx.sender());

} 

public entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64) {
    // Check if the balance of FAUCET_COIN object
    assert!(coin::value(coin) >= amount, EInsufficientFund);

    let split_balance = balance::split(coin::balance_mut(coin), amount);
    balance::join(&mut game.balance, split_balance);
}

public entry fun withdraw(game: &mut Game, _: &AdminCap, amount: u64, ctx: &mut TxContext) {
    assert!(balance::value(&game.balance) >= amount, EInsufficientFund);

    let money = coin::take(&mut game.balance, amount, ctx);
    transfer::public_transfer(money, ctx.sender());

}

public entry fun play(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64, number: u8, r: &Random, ctx: &mut TxContext) {
    assert!(coin::value(coin) >= amount, EInsufficientFund);
    assert!(balance::value(&game.balance) >= amount, EInsufficientFund);

    let mut generator = random::new_generator(r, ctx);
    let mut result = random::generate_u8_in_range(&mut generator, 1, 2); 

    if (number == result) {
        let gift = coin::take(&mut game.balance, amount, ctx);
        coin::join(coin, gift);
    }
    else {
        deposit(game, coin, amount);
    }
}