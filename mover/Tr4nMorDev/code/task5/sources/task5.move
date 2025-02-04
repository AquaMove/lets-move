

module task5::Tr4nMorDev{
    use faucet_coin::faucet_coin::FAUCET_COIN;
    use my_coin::my_coin::MY_COIN;

    use sui::coin;
    use sui::balance;   
    use sui::coin::{Coin};
    
    public struct Pool has key , store{ 
        id: UID,
        my_coin: balance::Balance<MY_COIN>,
        faucet_coin: balance::Balance<FAUCET_COIN>
    }
    fun init (ctx : &mut TxContext){
        let pool = Pool {
            id : object::new(ctx),
            my_coin : balance::zero<MY_COIN>(),
            faucet_coin : balance::zero<FAUCET_COIN>()
        };
        transfer::share_object(pool);
    }
    public entry fun add_money_to_pool(pool : &mut Pool ,my_coin : Coin<MY_COIN> , faucet_coin : Coin<FAUCET_COIN>){
        pool.my_coin.join(my_coin.into_balance());
        //public fun into_balance<T>(coin: Coin<T>): Balance<T> {
        //  let Coin { id, balance } = coin;
        //  id.delete();
        //  balance
        // }
//          public fun join<T>(self: &mut Balance<T>, balance: Balance<T>): u64 {
//              let Balance { value } = balance;
//              self.value = self.value + value;
//              self.value
//          }
        pool.faucet_coin.join(faucet_coin.into_balance());
    }
    public entry fun deposit_my_coin (pool : &mut Pool  , user_coin : Coin<MY_COIN>){
        coin::put(&mut pool.my_coin, user_coin);
    }   
//      public fun put<T>(balance: &mut Balance<T>, coin: Coin<T>) {
//           balance.join(into_balance(coin));
//      }
    public entry fun deposit_faucet_coin(pool : &mut Pool , user_coin : Coin<FAUCET_COIN>){
        coin::put(&mut pool.faucet_coin, user_coin);
    }
    public entry fun swap_my_coin_to_faucet_coin(pool : &mut Pool , my_coin : Coin<MY_COIN> , ctx : &mut TxContext){
        let amount = my_coin.value();
        assert!(amount > 0, 0);
        pool.my_coin.join(my_coin.into_balance());

        let output_coin  = coin::take(&mut pool.faucet_coin, amount, ctx );
        transfer::public_transfer(output_coin, ctx.sender());
    }

    public entry fun swap_faucet_coin_to_my_coin(pool : &mut Pool , faucet_coin : Coin<FAUCET_COIN> , ctx : &mut TxContext){
        let amount = faucet_coin.value();
        assert!(amount > 0, 0);
        pool.faucet_coin.join(faucet_coin.into_balance());

        let output_coin  = coin::take(&mut pool.my_coin,
         amount, ctx );
    //  public fun take<T>(balance: &mut Balance<T>, value: u64, ctx: &mut TxContext): Coin<T> {
    //      Coin {
    //          id: object::new(ctx),
    //          balance: balance.split(value),
    //      }
//        }
    //  public fun split<T>(self: &mut Balance<T>, value: u64): Balance<T> {
    //      assert!(self.value >= value, ENotEnough);
    //      self.value = self.value - value;
    //      Balance { value }
//      }
        transfer::public_transfer(output_coin, ctx.sender());
    }
}