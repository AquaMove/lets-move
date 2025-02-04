/*
/// Module: mygame
module mygame::mygame;
*/

module 0x0::task4_game{

    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::random::{Self, Random};

   use my_coin::my_coin::MY_COIN;

   public struct Game has key {
    id: UID,
    balance: Balance<MY_COIN>,
   }

   public struct Admin has key {
    id:UID,
   }

   fun init (ctx: &mut TxContext){

        transfer::share_object(Game {
            id: object::new(ctx),
            balance: balance::zero<MY_COIN>()
        });

        transfer::transfer(Admin {
            id: object::new(ctx)
        }, ctx.sender())
       
   }

   entry fun deposit(
        game: &mut Game,
        coin: &mut Coin<MY_COIN>,
        amount: u64
   ){
        let split_balance = balance::split(coin::balance_mut(coin), amount);
        
        balance::join(&mut game.balance, split_balance);
   }

   entry fun withdraw(
        game: &mut Game,
        _: &Admin,
        amout: u64,
        ctx: &mut TxContext
   ){
        let cash = coin::take(&mut game.balance, amout, ctx);
        
        transfer::public_transfer(cash, ctx.sender());
   }

   entry fun play(
        game: &mut Game,
        rnd: &Random,
        guess: bool, 
        coin: &mut Coin<MY_COIN>,
        ctx: &mut TxContext
    ) {
        
        let mut gen = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut gen);

        if(flag == guess){
           let reward =  coin::take(&mut game.balance, 1_000_000_000, ctx );
           coin::join(coin, reward);

          }else {
            deposit(game, coin, 1_000_000_000);
          }
     }
}

