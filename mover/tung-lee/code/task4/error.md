Error when publish contract but build successfully

```
error[E03004]: unbound type
   ┌─ /lets-move/mover/tung-lee/code/task4/sources/task4.move:21:36
   │
21 │             balance: balance::zero<FAUCET_COIN>()
   │                                    ^^^^^^^^^^^ Unbound type 'FAUCET_COIN' in current scope

error[E03004]: unbound type
   ┌─ /lets-move/mover/tung-lee/code/task4/sources/task4.move:29:56
   │
29 │     entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64)  {
   │                                                        ^^^^^^^^^^^ Unbound type 'FAUCET_COIN' in current scope

error[E03004]: unbound type
   ┌─ /lets-move/mover/tung-lee/code/task4/sources/task4.move:40:80
   │
40 │     entry fun play(game: &mut Game, rnd: &Random, guess: bool, coin: &mut Coin<FAUCET_COIN>, ctx: &mut sui::tx_context::TxContext) {
   │                                                                                ^^^^^^^^^^^ Unbound type 'FAUCET_COIN' in current scope

Failed to build Move modules: Compilation error.
```