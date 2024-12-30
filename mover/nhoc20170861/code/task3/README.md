## How to test the **move_nft** package

1. Create the **move_nft** package
```sh
cd ~/mover-nhoc20170861/mover/nhoc20170861/code/task3
sui move new move_nft
```
- The structure of the `move_nft` package is as follows:
```sh
.
├── Move.toml
├── sources
│   └── move_nft.move
└── tests
    └── move_nft_tests.move
```
- Modify file [`move_nft.move`](mover/nhoc20170861/code/task3/my_coin/sources/move_nft.move) and write your source code 

2. Build your **move_nft** package
```sh
cd ~/mover/nhoc20170861/code/task3/move_nft 
# build this package
sui move build
```

Output:
```sh
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING move_nft
```

3. Publish your package and test it
- Publish the package (*I publish to the testnet*):
```sh
sui client publish
```
> [!NOTE]  
> I publish to the **testnet** network

- Test this package:

```sh
sui client call --package 0xd8378fd8cdbfb06a603e648d6281016634816f38dd7bd8d673b48b67637e8dd0 --module move_nft --function mint --args "hello! I'm nhoc20170861" 0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b
```