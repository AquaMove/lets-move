# Mint token `My Coin`
```
sui client call --package 0x8bfe3c76dfc8a1e65a25224cac75d3ec26e243c45e48a72fefa2d2576ecc1263 --module my_coin --function mint_token --args 0xe1b921c5ad1aa3feb31fe499ef396eaf310834b710f4956e626088b58574746f
```

# Mint and Transfer token `My Coin`
```
sui client call --package 0x2 --module coin --function mint_and_transfer --args 0xe1b921c5ad1aa3feb31fe499ef396eaf310834b710f4956e626088b58574746f 10000000 0x3b042837d6ea719c6a4e6da7feb34e33ea098cdfb0fe10cc3172151edacbdd21 --type-args 0x8bfe3c76dfc8a1e65a25224cac75d3ec26e243c45e48a72fefa2d2576ecc1263::my_coin::MY_COIN
```

# Transfer token `My Coin`
```
sui client transfer --to 0xa9ddd77d41119bdcbab0f5c4d18bf15e65034607afc5a296865f640e0d33d958 --object-id 0x7f363acb1e460d8b1c19790e66e7f99f94c0991600ff47ea9abf2dca7c17815c
```

# Mint token `Faucet Coin`
```
sui client call --package 0xf8d69746f4142542458b36bf9f92bb0b01284b24413872aaacd4e265bf9fe5f6 --module faucet_coin --function mint_token --args 0x3790f889232d5d8bda1ea32a4842a0727d7a9ed115f2a32284509429dbfd1d85
```
