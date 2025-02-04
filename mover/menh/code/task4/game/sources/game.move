module 0x0::game{
  use sui::balance::{Self, Balance};
  use sui::random::{Self, Random};
  use sui::coin::{Self, Coin};
  use faucet_coin::faucet_coin::FAUCET_COIN;


  public struct Game has key {
      id: UID,
      balance:  Balance<FAUCET_COIN>
    }

  public struct Admin has key{
      id: UID,
    }

  fun init(ctx: &mut TxContext){
      transfer::share_object(
        Game{
          id: object::new(ctx),
          balance: balance::zero<FAUCET_COIN>()
        }
      );

      transfer::transfer(
        Admin{ 
          id: object::new(ctx)
        },
        ctx.sender()
      )
    }

  entry fun deposit(
    game: &mut Game,
    coin: &mut Coin<FAUCET_COIN>,
    amount: u64
  ){
      let split_balance = balance::split(coin::balance_mut(coin), amount);
      balance::join(&mut game.balance, split_balance);
    }
    

  entry fun withdraw(
    game: &mut Game,
    _: &Admin,
    amount: u64,
    ctx: &mut TxContext
  ){
      let cash = coin::take(&mut game.balance, amount, ctx);
      transfer::public_transfer(cash, ctx.sender());
    }
    
  entry fun play(
      game: &mut Game,
      rnd: &Random,
      guess: bool,
      coin: &mut Coin<FAUCET_COIN>,
      ctx: &mut TxContext
    ){
      let mut gen = random::new_generator(rnd, ctx);
      let flag = random::generate_bool(&mut gen);

      if(flag == guess){
          let reward = coin::take(&mut game.balance, 1_000_000_000, ctx);
          coin::join(coin, reward)
        } 
      else {
          deposit(game, coin, 1_000_000_000);
        }
    }

  }
//sui client call --package 0xa1a2269d61afe5ae66e78894246406b3679705310203d400921b12603ad3ae2f --module game --function play --args 0xa57d1fd81940b425c7679119c81f3cbe2d405dba62ed3d5882dcae5c
c7e92fac 0x8 false 0x61a5baa559bfd7a50aeaf88822246f76f86bd21ecd8ddf8ad00056dab04ba6e4
