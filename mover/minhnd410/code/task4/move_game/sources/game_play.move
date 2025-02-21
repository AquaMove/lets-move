module move_game::game_play;

use sui::coin::{Self, Coin};
use sui::balance::Balance;
use sui::bls12381::bls12381_min_pk_verify;
use sui::hash::{blake2b256};
use std::string::String;
use sui::dynamic_object_field::{Self as dof};

use move_game::fund_pool::FundPool;
use move_game::game_counter::GameCounter;
use move_faucet_coin::minhnd410_Faucet::{MINHND410_FAUCET};

const HEADS: vector<u8> = b"H";
const TAILS: vector<u8> = b"T";

const EInvalidBlsSig: u64 = 2;
const EInvalidGuess: u64 = 4;
const EInsufficientFundPoolBalance: u64 = 5;
const EGameDoesNotExist: u64 = 6;

const PLAYER_WON_STATE: u8 = 1;
const PLAYER_LOSE_STATE: u8 = 2;

public struct Game has key, store {
    id: UID,
    guess_placed_epoch: u64,
    total_stake: Balance<MINHND410_FAUCET>,
    guess: String,
    player: address,
    vrf_input: vector<u8>,
    github_id: vector<u8>,
}

public fun start_game(guess: String, counter: &mut GameCounter, coin: Coin<MINHND410_FAUCET>, fund_pool: &mut FundPool, ctx: &mut TxContext): ID {
    map_guess(guess);
    let user_stake = coin.value();
    assert!(fund_pool.balance() >= user_stake, EInsufficientFundPoolBalance);

    let mut total_stake = fund_pool.borrow_balance_mut().split(user_stake);
    coin::put(&mut total_stake, coin);

    let vrf_input = counter.get_vrf_input_and_increment();

    let id = object::new(ctx);
    let game_id = object::uid_to_inner(&id);

    let new_game = Game {
        id,
        guess_placed_epoch: ctx.epoch(),
        total_stake,
        guess,
        player: ctx.sender(),
        vrf_input,
        github_id: b"minhnd410"
    };

    dof::add(fund_pool.borrow_mut(), game_id, new_game);
    game_id
}

public fun finish_game(game_id: ID, bls_sig: vector<u8>, fund_pool: &mut FundPool, ctx: &mut TxContext) {
    assert!(game_exists(fund_pool, game_id), EGameDoesNotExist);

    let Game {
        id,
        guess_placed_epoch: _,
        total_stake,
        guess,
        player,
        vrf_input,
        github_id: _,
    } = dof::remove<ID, Game>(fund_pool.borrow_mut(), game_id);

    object::delete(id);

    // Step 1: Check the BLS signature, if its invalid abort.
    let is_sig_valid = bls12381_min_pk_verify(&bls_sig, &fund_pool.public_key(), &vrf_input);
    assert!(is_sig_valid, EInvalidBlsSig);

    // Hash the beacon before taking the 1st byte.
    let hashed_beacon = blake2b256(&bls_sig);
    // Step 2: Determine winner.
    let first_byte = hashed_beacon[0];
    let player_won = map_guess(guess) == (first_byte % 2);

    // Step 3: Distribute funds based on result.
    if (player_won) {
        transfer::public_transfer(total_stake.into_coin(ctx), player);
        PLAYER_WON_STATE
    } else {
        fund_pool.borrow_balance_mut().join(total_stake);
        PLAYER_LOSE_STATE
    };
}

// --------------- Public Helper functions ---------------

public fun game_exists(fund_pool: &FundPool, game_id: ID): bool {
    dof::exists_(fund_pool.borrow(), game_id)
}

// --------------- Internal Helper functions ---------------

/// Helper function to map (H)EADS and (T)AILS to 0 and 1 respectively.
/// H = 0
/// T = 1
fun map_guess(guess: String): u8 {
    let heads = HEADS;
    let tails = TAILS;
    assert!(guess.as_bytes() == heads || guess.as_bytes() == tails, EInvalidGuess);

    if (guess.as_bytes() == heads) {
        0
    } else {
        1
    }
}