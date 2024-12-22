module move_game::fund_pool;

use sui::balance::{Balance};
use sui::coin::{Self, Coin};
use sui::package::{Self};

use move_faucet_coin::minhnd410_Faucet::{MINHND410_FAUCET};

const ECallerNotOwner: u64 = 0;
const EInsufficientBalance: u64 = 1;

public struct FundPool has key {
  id: UID,
  balance: Balance<MINHND410_FAUCET>,
  owner: address,
  public_key: vector<u8>,
  github_id: vector<u8>,
}

public struct FundPoolCap has key {
  id: UID
}

public struct FUND_POOL has drop {}

fun init(otw: FUND_POOL, ctx: &mut TxContext) {
  package::claim_and_keep(otw, ctx);

  let fund_pool_cap = FundPoolCap {
    id: object::new(ctx)
  };

  transfer::transfer(fund_pool_cap, ctx.sender());
}

public fun initialize_fund_pool(fund_pool_cap: FundPoolCap, coin: Coin<MINHND410_FAUCET>, public_key: vector<u8>, ctx: &mut TxContext) {
  assert!(coin.value() > 0, EInsufficientBalance);

  let fund_pool = FundPool {
    id: object::new(ctx),
    balance: coin.into_balance(),
    owner: ctx.sender(),
    public_key,
    github_id: b"minhnd410"
  };

  let FundPoolCap { id } = fund_pool_cap;
  object::delete(id);

  transfer::share_object(fund_pool);
}

public fun deposit(fund_pool: &mut FundPool, coin: Coin<MINHND410_FAUCET>, _: &mut TxContext) {
  coin::put(&mut fund_pool.balance, coin)
}

public fun withdraw(fund_pool: &mut FundPool, ctx: &mut TxContext) {
  assert!(ctx.sender() == fund_pool.owner(), ECallerNotOwner);

  let total_balance = balance(fund_pool);
  let coin = coin::take(&mut fund_pool.balance, total_balance, ctx);
  transfer::public_transfer(coin, fund_pool.owner());
}

// --------------- Mutable References ---------------

public(package) fun borrow_balance_mut(fund_pool: &mut FundPool): &mut Balance<MINHND410_FAUCET> {
  &mut fund_pool.balance
}

public(package) fun borrow_mut(fund_pool: &mut FundPool): &mut UID {
  &mut fund_pool.id
}

// --------------- Read-only References ---------------
public(package) fun borrow(fund_pool: &FundPool): &UID {
  &fund_pool.id
}

public fun public_key(fund_pool: &FundPool): vector<u8> {
  fund_pool.public_key
}

public fun owner(fund_pool: &FundPool): address {
  fund_pool.owner
}

public fun balance(fund_pool: &FundPool): u64 {
  fund_pool.balance.value()
}