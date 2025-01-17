module task_5_swap::task_5_swap {
    use faucet_token::faucet_token::FAUCET_TOKEN;
    use token::token::TOKEN;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    public struct Pool has key {
        id: UID,
        token: Balance<TOKEN>,
        faucet_token: Balance<FAUCET_TOKEN>
    }

    fun init (ctx: &mut TxContext){
        let pool = Pool{
            id:object::new(ctx),
            token: balance::zero<TOKEN>(),
            faucet_token: balance::zero<FAUCET_TOKEN>()
        };
        transfer::share_object(pool);
    }

    public entry fun add_money_to_pool(pool: &mut Pool, token: Coin<TOKEN>, faucet_token: Coin<FAUCET_TOKEN>){
        pool.token.join(token.into_balance());
        pool.faucet_token.join(faucet_token.into_balance());
    }

    public entry fun deposit_token (pool: &mut Pool , token: Coin<TOKEN>){
        coin::put( &mut pool.token, token);
    }

    public entry fun deposit_faucet_token (pool: &mut Pool , faucet_token: Coin<FAUCET_TOKEN>){
        coin::put( &mut pool.faucet_token, faucet_token);
    }

    public entry fun swap_my_token_to_token(pool: &mut Pool, token: Coin<TOKEN>, ctx: &mut TxContext){
        let amount = coin::value(&token);
        assert!(amount > 0, 0);
        pool.token.join(token.into_balance());
       let coin = coin::take(&mut pool.faucet_token, amount, ctx);
       transfer::public_transfer(coin,ctx.sender());
    }
    public entry fun swap_faucet_token_to_token(pool: &mut Pool, faucet_token: Coin<FAUCET_TOKEN>, ctx: &mut TxContext){
        let amount = coin::value(&faucet_token);
        assert!(amount > 0, 0);
        pool.faucet_token.join(faucet_token.into_balance());
       let coin = coin::take(&mut pool.faucet_token, amount, ctx);
       transfer::public_transfer(coin,ctx.sender());
    }
}
