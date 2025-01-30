module lamdanghoang::lamdanghoang {
    
    use my_coin::my_coin::MY_COIN;
    use faucet_coin::faucet_coin::FAUCET_COIN;
    use sui::balance::{ Self, Balance };
    use sui::coin::{ Self, Coin };

    public struct AdminCap has key {
        id: UID,
    }

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

        let admin = AdminCap { id: object::new(ctx) };
        transfer::transfer(admin, ctx.sender());
    }

    public entry fun deposit_my_coin(pool: &mut Pool, user_coin: Coin<MY_COIN>, amount: u64, ctx: &mut TxContext) {
        let coin_value = user_coin.value();
        assert!(coin_value >= amount, 0);

        let mut user_balance = user_coin.into_balance();

        if (coin_value == amount) {
            balance::join(&mut pool.my_coin, user_balance);
        } else {
            balance::join(&mut pool.my_coin, balance::split(&mut user_balance, amount));
            let remaining_coin = coin::from_balance(user_balance, ctx);
            transfer::public_transfer(remaining_coin, ctx.sender());
        }
    }

    public entry fun deposit_faucet_coin(pool: &mut Pool, user_coin: Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
        let coin_value = user_coin.value();
        assert!(coin_value >= amount, 0);

        let mut user_balance = user_coin.into_balance();

        if (coin_value == amount) {
            balance::join(&mut pool.faucet_coin, user_balance);
        } else {
            balance::join(&mut pool.faucet_coin, balance::split(&mut user_balance, amount));
            let remaining_coin = coin::from_balance(user_balance, ctx);
            transfer::public_transfer(remaining_coin, ctx.sender());
        }
    }

    public entry fun withdraw_my_coin(_: &AdminCap, pool: &mut Pool, amount: u64, ctx: &mut TxContext) {
        let pool_value = pool.my_coin.value();
        assert!(pool_value >= amount, 1);

        let withdraw_balance = balance::split(&mut pool.my_coin, amount);
        let withdraw_coin = coin::from_balance(withdraw_balance, ctx);

        transfer::public_transfer(withdraw_coin, ctx.sender());
    }

    public entry fun withdraw_faucet_coin(_: &AdminCap, pool: &mut Pool, amount: u64, ctx: &mut TxContext) {
        let pool_value = pool.faucet_coin.value();
        assert!(pool_value >= amount, 1);

        let withdraw_balance = balance::split(&mut pool.faucet_coin, amount);
        let withdraw_coin = coin::from_balance(withdraw_balance, ctx);

        transfer::public_transfer(withdraw_coin, ctx.sender());
    }

    public entry fun swap_my_coin_to_faucet_coin(pool: &mut Pool, user_coin: Coin<MY_COIN>, amount: u64, ctx: &mut TxContext) {
        deposit_my_coin(pool, user_coin, amount, ctx);

        // Rate 1:1
        let output_balance = balance::split(&mut pool.faucet_coin, amount);
        let output_coin = coin::from_balance(output_balance, ctx);

        transfer::public_transfer(output_coin, ctx.sender());
    }

    public entry fun swap_faucet_coin_to_my_coin(pool: &mut Pool, user_coin: Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
        deposit_faucet_coin(pool, user_coin, amount, ctx);

        // Rate 1:1
        let output_balance = balance::split(&mut pool.my_coin, amount);
        let output_coin = coin::from_balance(output_balance, ctx);

        transfer::public_transfer(output_coin, ctx.sender());
    }
}