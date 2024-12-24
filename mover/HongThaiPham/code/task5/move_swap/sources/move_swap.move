/*
/// Module: move_swap
module move_swap::move_swap;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module move_swap::hongthaipham_swap {
  use sui::coin::{Self, Coin, TreasuryCap};
  use sui::balance::{Self, Balance};
  use faucet_coin::faucet_coin::{FAUCET_COIN};
  use my_coin::my_coin::{MY_COIN};


  const EInvalidAmount: u64 = 0;
  const EInsufficientLiquidityMinted: u64 = 1;
  const EZeroAmount: u64 = 2;
  const ENoValidSwapValue: u64 = 3;

  const MINIMUM_LIQUIDITY: u64 = 1000;

  public struct HONGTHAIPHAM_SWAP has drop {}

  public struct Pair has key {
    id: UID,
    balance_x: Balance<FAUCET_COIN>,
    balance_y: Balance<MY_COIN>,
    lp_cap: TreasuryCap<HONGTHAIPHAM_SWAP>,
    lp_locked: Balance<HONGTHAIPHAM_SWAP>
  }

  fun init(otw: HONGTHAIPHAM_SWAP, ctx: &mut TxContext){
    let treasury_cap = create_lp(otw, ctx);
    let pair = Pair {
      id: object::new(ctx),
      balance_x: balance::zero(),
      balance_y: balance::zero(),
      lp_cap: treasury_cap,
      lp_locked: balance::zero()
    };
    transfer::share_object(pair);
  }

  fun create_lp(otw: HONGTHAIPHAM_SWAP, ctx: &mut TxContext): TreasuryCap<HONGTHAIPHAM_SWAP> {
    let (treasury_cap, metadata) = coin::create_currency(
            otw, 
            6,
            b"LPC",
            b"HongThaiPham LP Coin",
            b"The LP Coin for HongThaiPham",
            option::none(), 
            ctx
        );

    transfer::public_freeze_object(metadata);
    treasury_cap
  }

  public entry fun add_liquidity(pair: &mut Pair, coin_x: &mut Coin<FAUCET_COIN>, max_amount_x: u64, coin_y: &mut Coin<MY_COIN>, max_amount_y: u64, ctx: &mut TxContext) {
    let reserve_x = pair.balance_x.value();
    let reserve_y = pair.balance_y.value();
    
    let coin_x_value = coin::value(coin_x);
    let coin_y_value = coin::value(coin_y);

    assert!(max_amount_x > 0 && max_amount_y > 0, EZeroAmount);
    assert!(coin_x_value >= max_amount_x && coin_y_value >= max_amount_y, EInvalidAmount);

    
    let total_supply = coin::total_supply(&pair.lp_cap);

    let (amount_x, amount_y) = if (total_supply == 0) {
        (max_amount_x, max_amount_y)
    } else {
        let dx = calculate_desired_amount_deposit(reserve_x, reserve_y, max_amount_y);
        if (max_amount_x >= dx) {
            (dx, max_amount_y)
        } else {
            let dy = calculate_desired_amount_deposit(reserve_y, reserve_x, max_amount_x);
            (max_amount_x, dy)
        }
    };


    let coin_x_deposit = coin::split(coin_x, amount_x, ctx);
    let coin_y_deposit = coin::split(coin_y, amount_y, ctx);

    coin::put(&mut pair.balance_x, coin_x_deposit);
    coin::put(&mut pair.balance_y, coin_y_deposit);

    let liquidity = if (total_supply == 0) {
        let locked_liquidity = coin::mint<HONGTHAIPHAM_SWAP>(
            &mut pair.lp_cap, 
            MINIMUM_LIQUIDITY, 
            ctx
        );
        coin::put(&mut pair.lp_locked, locked_liquidity);
        (std::u64::sqrt(amount_x * amount_y) as u64) - MINIMUM_LIQUIDITY

    } else {
      (std::u64::min(amount_x * total_supply / reserve_x, amount_y * total_supply / reserve_y) as u64)
    };

    assert!(liquidity >= MINIMUM_LIQUIDITY, EInsufficientLiquidityMinted);

    coin::mint_and_transfer<HONGTHAIPHAM_SWAP>(&mut pair.lp_cap, liquidity, tx_context::sender(ctx), ctx);
  }

  public entry fun remove_liquidity(pair: &mut Pair, coin_lp: Coin<HONGTHAIPHAM_SWAP>, ctx: &mut TxContext) {
    let total_supply = coin::total_supply(&pair.lp_cap);
    assert!(total_supply > 0, EZeroAmount);
    let shares = coin::value(&coin_lp);
    assert!(shares > 0, EZeroAmount);
    // debug::print(&shares);

    let reserve_x = pair.balance_x.value();
    let reserve_y = pair.balance_y.value();

    let (amount_x, amount_y) = calculate_x_y_amount_return(reserve_x, reserve_y, shares, total_supply);
    // debug::print(&amount_x);
    // debug::print(&amount_y);
    assert!(amount_x > 0 && amount_y > 0, EZeroAmount);

    // burn shares
    coin::burn(&mut pair.lp_cap, coin_lp);

    // transfer X and Y to sender
    let coin_x = coin::take(&mut pair.balance_x, amount_x, ctx);
    let coin_y = coin::take(&mut pair.balance_y, amount_y, ctx);

    transfer::public_transfer(coin_x, tx_context::sender(ctx));
    transfer::public_transfer(coin_y, tx_context::sender(ctx));
  }

  public entry fun swap_to_y(pair: &mut Pair, coin_x: Coin<FAUCET_COIN>, min_amount_out: u64, ctx: &mut TxContext) {
    let reserve_x = pair.balance_x.value();
    let reserve_y = pair.balance_y.value();

    let coin_x_value = coin_x.value();

    assert!(coin_x_value > 0 && min_amount_out > 0, EZeroAmount);
   

    let amount_y_received = calculate_desired_amount_withdraw(reserve_x, reserve_y, coin_x_value);
    assert!(amount_y_received >= min_amount_out, ENoValidSwapValue);

    coin::put(&mut pair.balance_x, coin_x);
    
    let coin_y = coin::take(&mut pair.balance_y, amount_y_received, ctx);
    transfer::public_transfer(coin_y, tx_context::sender(ctx));
  }

  public entry fun swap_to_x(pair: &mut Pair, coin_y: Coin<MY_COIN>, min_amount_out: u64, ctx: &mut TxContext) {
    let reserve_x = pair.balance_x.value();
    let reserve_y = pair.balance_y.value();

    let coin_y_value = coin_y.value();

    assert!(coin_y_value > 0 && min_amount_out > 0, EZeroAmount);
   

    let amount_x_received = calculate_desired_amount_withdraw(reserve_y, reserve_x, coin_y_value);
    assert!(amount_x_received >= min_amount_out, ENoValidSwapValue);

    coin::put(&mut pair.balance_y, coin_y);
    
    let coin_x = coin::take(&mut pair.balance_x, amount_x_received, ctx);
    transfer::public_transfer(coin_x, tx_context::sender(ctx));
  }



  // Calculate the desired amount of Y to withdraw a of X
  // dy = Y.dx / (X + dx)
  public fun calculate_desired_amount_withdraw(x: u64, y: u64, a: u64) : u64 {
    (y * a / (x + a)) as u64
  }

  // Calculate the amount X and Y will receive when burn a of shares
  // dx = X * s / T
  // dy  = Y * s / T
  public fun calculate_x_y_amount_return(x: u64, y: u64, s: u64, t: u64) : (u64, u64) {
    let amount_x = (x * s / t) as u64;
    let amount_y = (y * s / t) as u64;

    (amount_x, amount_y)
  }

  // Calculate the amount of X must deposit to get a of Y
  // dx = X. dy / Y
  public fun calculate_desired_amount_deposit(x: u64, y: u64, a: u64): u64 {
    (x * a / y) as u64
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(HONGTHAIPHAM_SWAP{},ctx);
  }

  #[test_only]
  public fun balance_x(pair: &Pair): u64 {
    pair.balance_x.value()
  }

  #[test_only]
  public fun balance_y(pair: &Pair): u64 {
    pair.balance_y.value()
  }

  #[test_only]
  public fun lp_total_supply(pair: &Pair): u64 {
    coin::total_supply(&pair.lp_cap)
  }

}
