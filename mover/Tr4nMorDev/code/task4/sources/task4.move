/*
/// Module: task4
module task4::task4;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module task4::task4 {
    use sui::coin::{Self,Coin};
    use sui::balance::{Self,Balance};
    use sui::random::{Self, Random};
    use std::debug;
    use faucet_coin::faucet_coin;
    
    public struct Game has key, store {
        id: UID,
        balance: Balance<faucet_coin::FAUCET_COIN>,
        id_admin_Tr4nMorDev: address
        // id_admin_Tr4nMorDev: 0x4292aa0b0a7a0c1c196fc7dcaea31507814a8f5ce043a904d48217d9cd8d73b4
    }
    public struct Admin has key ,  store {
        id: UID,
    }

    fun init (ctx: &mut TxContext) {
        let game = Game {   
            id : object::new(ctx),
            balance : balance::zero<faucet_coin::FAUCET_COIN>(),
            id_admin_Tr4nMorDev :  ctx.sender() 
        };
        transfer::share_object(game); 
        let admin  = Admin{id : object::new(ctx)}; 
        transfer::transfer(admin,   ctx.sender());
    }   
    public  entry fun deposit (game : &mut Game , coin : &mut Coin<faucet_coin::FAUCET_COIN> ,amount : u64 ){
        let  mu_coin = coin::balance_mut(  coin);
        let  split_balance = balance::split(mu_coin,amount); 
        balance::join(&mut game.balance, split_balance);
           
    }   
    public entry fun withdraw (amount : u64 , game : &mut Game , ctx: &mut TxContext){
            let cash = coin::take(&mut game.balance, amount, ctx);
            transfer::public_transfer(cash, ctx.sender());
        }
    public fun takeReward (game : &mut Game  , coin:&mut Coin<faucet_coin::FAUCET_COIN> , amount : u64){
        let amount = amount * 2 ;
        let reward_balance = balance::split(&mut game.balance, amount);
        balance::join(coin::balance_mut( coin), reward_balance);
    }
    
    public fun deduct_money (game : &mut Game ,coin :&mut Coin<faucet_coin::FAUCET_COIN>, amount : u64):u64{
        let un = balance::split(coin.balance_mut(), amount);
        balance::join(&mut game.balance, un)
    }

    entry fun play_game_tai_xiu(
        guess: bool,
        game: &mut Game,
        rnd: &Random, 
        coin: &mut Coin<faucet_coin::FAUCET_COIN>,
        amount : u64,
        ctx: &mut TxContext
    ) {
        let mut gen = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut gen);
        let over = b"over";
        let under = b"under";


        if(&flag == guess && guess == true) {
            debug::print(&over);
            takeReward(game, coin, amount);
        } else if(&flag == guess && guess == false) {
            debug::print(&under);
            takeReward(game, coin, amount);
        } else if(&flag != guess && guess == true) {
            debug::print(&under);
            deduct_money(game, coin, amount);
        } else  {
            debug::print(&over);
            deduct_money(game, coin, amount);
        }
    }

}