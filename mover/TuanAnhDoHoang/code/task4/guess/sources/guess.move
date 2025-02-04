/*
/// Module: guess
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module guess::TuanAnhDoHoang_coin;
use sui::{
    balance::{Self, Balance},
    sui::SUI,
    coin::{Self, Coin},
    random::{Self, Random},
    object,
    url,
};
public struct TUANANHDOHOANG_COIN has drop{}
public struct GameInfo has key {
    id: UID,
    pool: Balance<TUANANHDOHOANG_COIN>,
}
public struct Player has key{
    id: UID,
    coin_inner: u64,
}
fun create(ctx: &mut TxContext){
    transfer::share_object(GameInfo{
        id: object::new(ctx),
        pool: balance::zero(),
    });
    transfer::transfer(Player{
        id: object::new(ctx),
        coin_inner: 0,
    }, ctx.sender());
}
public fun player_deposit_coin(game: &mut GameInfo, player: &mut Player, payment: Coin<TUANANHDOHOANG_COIN>){
    player.coin_inner = player.coin_inner + coin::value(&payment);
    coin::put(&mut game.pool, payment);
}
// public fun player_withdrawall_coin(game: &mut GameInfo, amount: u64, ctx:&mut TxContext){
//     let player_coin_withdraw: Coin<SUI> = coin::from_balance(balance::split(&mut game.pool,amount), ctx);
//     transfer::public_transfer(player_coin_withdraw, ctx.sender());
// }
public fun faucet_coin(coin_return: Coin<TUANANHDOHOANG_COIN>, ctx: &mut TxContext){
    transfer::public_transfer(coin_return,ctx.sender());
}
const MIN_COST_GAME: u64 = 5;
const EINSUFFICIENT_FUNDS: u64 = 3;

public fun play_game(choosen: u64, r: &Random, game: &mut GameInfo, player: &mut Player, ctx: &mut TxContext){
    let value = player.coin_inner;
    assert!(value >= MIN_COST_GAME, EINSUFFICIENT_FUNDS);
    let mut generator = random::new_generator(r, ctx);
    let number = random::generate_u64_in_range(&mut generator,10,80);
    let mut reward = 0;
    if(choosen == number){
        //cắt lượng vốn + thưởng từ pool gửi trả về player
        reward = value + 2;
    }
    else{
        reward = value - 2;
    };

    let return_coin:Coin<TUANANHDOHOANG_COIN> = coin::take(&mut game.pool, reward, ctx);
    player.coin_inner = player.coin_inner - reward;
    faucet_coin(return_coin, ctx);
}

// Cấu hình hàm init để phát vốn đầu cho player

use sui::coin::TreasuryCap;

fun init(witness: TUANANHDOHOANG_COIN, ctx:&mut TxContext){
    let (mut treasury, metadata) = coin::create_currency(witness, 6, b"TUANANHDOHOANG", b"TUANANHDOHOANG", b"TUANANHDOHOANG coin", option::none(), ctx);  
    let mint_coin = coin::mint(&mut treasury,5 , ctx);
    transfer::public_transfer(mint_coin, ctx.sender());
    transfer::public_freeze_object(metadata);  
    transfer::public_freeze_object(treasury); //Khôn ai truy cập được nữa (chỉ có thể "tự" mint trong lúc init)
    create(ctx);
    //player_deposit_coin(game: &mut GameInfo, player: &mut Player, payment: Coin<GUESS>)
    //play_game(choosen: u64, r: &Random, game: &mut GameInfo, player: &mut Player, ctx: &mut TxContext)
}
