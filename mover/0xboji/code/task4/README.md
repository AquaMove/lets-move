# Task 4: Sui Move Game

A coin-flip game on Sui blockchain using BOJI_COIN_FAUCET tokens.

## Contract Information
- Game Package ID: `0x611d4b8168283fc9721857cf0981165305c70f6d9ef87de35d594bb24a8cc446`
- Game Object ID: `0x723bd90b2857ab87cb0f4ceb46d149e34dc1ead77428ede50b9d33212ba20e37`
- Faucet Token Package ID: `0x5b74d1677ea1fdc492ac42f813e19b1b8ca48fe9f8eb5d12d84eff2cb0cf5449`
- Random Object ID: `0x8`

## Game Rules
1. Players can bet BOJI_COIN_FAUCET tokens
2. Game must have 10x the bet amount in balance
3. Players guess true/false for a coin flip
4. If correct, player gets 2x their bet
5. If wrong, player loses their bet

## CLI Examples

### 1. Mint Game Tokens
Mint 1,000,000 BOJI_COIN_FAUCET tokens

```
sui client call \
--package 0x5b74d1677ea1fdc492ac42f813e19b1b8ca48fe9f8eb5d12d84eff2cb0cf5449 \
--module boji_coin_faucet \
--function mint \
--type-args 0x5b74d1677ea1fdc492ac42f813e19b1b8ca48fe9f8eb5d12d84eff2cb0cf5449::boji_coin_faucet::BOJI_COIN_FAUCET \
--args 0x353758a0815ab0472d76b328b2355587ffa8e7365a8471001b2f09b5f364fa6b 1000000 0xf96d3494f9fff2883d5f5890424041354625d9534d26d2ab24201d04ff9cc854 \
--gas-budget 10000000
```
### 2. Deposit to Game
Deposit tokens to game balance
```
sui client call \
--package 0x611d4b8168283fc9721857cf0981165305c70f6d9ef87de35d594bb24a8cc446 \
--module my_game \
--function DepositCoin \
--args 0x723bd90b2857ab87cb0f4ceb46d149e34dc1ead77428ede50b9d33212ba20e37 <YOUR_COIN_ID> \
--gas-budget 10000000
```

### 3. Play the Game
Play with a bet and guess true
```
sui client call \
--package 0x611d4b8168283fc9721857cf0981165305c70f6d9ef87de35d594bb24a8cc446 \
--module my_game \
--function play \
--args 0x723bd90b2857ab87cb0f4ceb46d149e34dc1ead77428ede50b9d33212ba20e37 0x8 true <YOUR_COIN_ID> \
--gas-budget 10000000
```
### 4. Admin Withdrawal
Withdraw tokens (admin only)

```
sui client call \
--package 0x611d4b8168283fc9721857cf0981165305c70f6d9ef87de35d594bb24a8cc446 \
--module my_game 
--function WithdrawCoin \
--args <ADMIN_CAP_ID> 0x723bd90b2857ab87cb0f4ceb46d149e34dc1ead77428ede50b9d33212ba20e37 <AMOUNT> \
--gas-budget 10000000
```

### 5. Check Objects

Check all objects
```
sui client objects
```
