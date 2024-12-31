## How to test the **my_coin** package

1. Create the **my_coin** package
```sh
cd ~/mover-nhoc20170861/mover/nhoc20170861/code/task2
sui move new my_coin
```
- The structure of the `my_coin` package is as follows:
```sh
.
├── Move.toml
├── sources
│   └── my_coin.move
└── tests
    └── move_coin_tests.move
```
- Modify file [`my_coin.move`](mover/nhoc20170861/code/task2/my_coin/sources/my_coin.move) and write your source code 

2. Build your **my_coin** package
```sh
cd ~/mover/nhoc20170861/code/task2/my_coin 
# build this package
sui move build
```

Output:
```sh
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING my_coin
```

3. Publish your package and test it
- Publish the package (*I publish to the testnet*):
```sh
sui client publish --gas-budget 100000000
```
> [!NOTE]  
> I publish to the **testnet** network

Output: ObjectID for the treasuryCap
```sh
 ┌──                                                                                                                          │
│  │ ObjectID: 0x76eefb2117a4600b3119ff7e361e05400790342800cf9919a4ab721230cb02ef                                               │
│  │ Sender: 0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b                                                 │
│  │ Owner: Account Address ( 0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b )                              │
│  │ ObjectType: 0x2::coin::TreasuryCap<0x22f468520532bc30fb69c1cb50df08981273a313f8549e42e7b332f658b8bd47::my_coin::MY_COIN>   │
│  │ Version: 289573228                                                                                                         │
│  │ Digest: HKheSCc7pzxJ62PbjHJmr6ipf3WpHo3bFiGA4zqqc31Z                                                                       │
│  └──                                                
```
- Test this package:

```sh
sui client call --package 0x22f468520532bc30fb69c1cb50df08981273a313f8549e42e7b332f658b8bd47 --module my_coin --function mint_token --args 0x76eefb2117a4600b3119ff7e361e05400790342800cf9919a4ab721230cb02ef 10000 0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b
```


## How to test the **faucet_coin** package

1. Create the **faucet_coin** package
```sh
cd ~/mover-nhoc20170861/mover/nhoc20170861/code/task2
sui move new faucet_coin
```
- The structure of the `faucet_coin` package is as follows:
```sh
.
├── Move.toml
├── sources
│   └── faucet_coin.move
└── tests
    └── faucet_coin_tests.move
```
- Modify file [`faucet_coin.move`](mover/nhoc20170861/code/task2/faucet_coin/sources/faucet_coin.move) and write your source code 

2. Build your **faucet_coin** package
```sh
cd ~/mover/nhoc20170861/code/task2/faucet_coin 
# build this package
sui move build
```

Output:
```sh
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING faucet_coin
```

3. Publish your package and test it
- Publish the package (*I publish to the testnet*):
```sh
sui client publish --gas-budget 100000000
```
> [!NOTE]  
> I publish to the **testnet** network

Output: ObjectID for the shared coin

```sh
┌──                                                                                              │
│  │ ID: 0x4cff8dda6e54dfac06dde2f4d340c39f91570c15bf369429f1694ce20b0c79db                         │
│  │ Owner: Shared( 289573233 )                                                                     │
│  │ Version: 289573233                                                                             │
│  │ Digest: 3emV5FQoCzs4JiVin2ij3KnrUsmRWTZXDDLnQWWA7q7P                                           │
│  └──                        
```
- Test this package:
  
  * Receipt address(1) :  
```sh
sui client call --package 0x81526d8512cd7e19610653ab8c3677da5dc6920fa4a168229d99d9f0cfddb658 --module faucet_coin --function mint_token --args 0x4cff8dda6e54dfac06dde2f4d340c39f91570c15bf369429f1694ce20b0c79db 10000 0xc02827b4a88c7244dc24993290cab3a6b7c7f37c845751505d06e5988289423a
```

  * Receipt address(2) :  
```sh
sui client call --package 0x81526d8512cd7e19610653ab8c3677da5dc6920fa4a168229d99d9f0cfddb658 --module faucet_coin --function mint_token --args 0x4cff8dda6e54dfac06dde2f4d340c39f91570c15bf369429f1694ce20b0c79db 10000 0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b
```