module menh1505::simpleSwap{

  use sui::coin::{Self, Coin};
  use sui::balance::{Self, Balance};
  use my_coin::my_coin::{MY_COIN};
  use faucet_coin::faucet_coin::{FAUCET_COIN};

  const ESufficientBalance :u64 = 1;
  const RATIO : u64 = 2;

  public struct Pool has key {
      id: UID,
      my_coin: Balance<MY_COIN>,
      faucet_coin: Balance<FAUCET_COIN>
  }

  fun init(ctx: &mut TxContext) {
      let pool = Pool {
          id: object::new(ctx),
          my_coin: balance::zero<MY_COIN>(),
          faucet_coin: balance::zero<FAUCET_COIN>()
      };

      transfer::share_object(pool);
  }

  public entry fun add_liq(pool: &mut Pool, my_coin: Coin<MY_COIN>, faucet_coin: Coin<FAUCET_COIN>) {
      coin::put(&mut pool.my_coin, my_coin);
      coin::put(&mut pool.faucet_coin, faucet_coin);

  }

  public entry fun deposit_my_coin(pool: &mut Pool, my_coin: &mut Coin<MY_COIN>, amount: u64, ctx: &mut TxContext) {
      assert!(coin::value(my_coin) >= amount, ESufficientBalance);

      let coin_transfer = coin::split(my_coin, amount, ctx);
      coin::put(&mut pool.my_coin, coin_transfer);
  }

  public entry fun deposit_faucet_coin(pool: &mut Pool, faucet_coin: &mut Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
      assert!(coin::value(faucet_coin) >= amount, ESufficientBalance);

      let coin_transfer = coin::split(faucet_coin, amount, ctx);
      coin::put(&mut pool.faucet_coin, coin_transfer);
  }

  // Ratio: 1 my_coin -> 2 faucet_coin
  public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, my_coin: &mut Coin<MY_COIN>, amount: u64, ctx: &mut TxContext) {
      assert!(coin::value(my_coin) >= amount, ESufficientBalance);
      assert!(balance::value(&pool.faucet_coin) >= RATIO*amount, ESufficientBalance);

      deposit_my_coin(pool, my_coin, amount, ctx);

      let coin_transfer = coin::take(&mut pool.faucet_coin, RATIO*amount, ctx);
      transfer::public_transfer(coin_transfer, ctx.sender());
  }

  public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, faucet_coin: &mut Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
      assert!(coin::value(faucet_coin) >= amount, ESufficientBalance);
      assert!(balance::value(&pool.my_coin) >= amount/RATIO, ESufficientBalance);

      deposit_faucet_coin(pool, faucet_coin, amount, ctx);

      let coin_transfer = coin::take(&mut pool.my_coin, amount/RATIO, ctx);
      transfer::public_transfer(coin_transfer, ctx.sender());
  }
}
//package: 0xe0296e616b5059385badcccd5d3274b96850f57e41273c034d31312480792e0e
//pool: 0x42f476405a7d9feeb51bf2abb1fbfb79b7d55d519f182f23b428d28d07fc6f9c
//mycoin:  0xe44e6376b030a101f0a62c38de49452967f1f55ff7a05b0f7a9703ae652c040f
//faucetcoin: 0x403fc20f267a7fd311766c07ec4ac60bc4af740f8595976d9e8ee4ddcf949cdf
