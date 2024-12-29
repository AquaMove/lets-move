## How to test this package

1. Faucet coins for the current address:
```sh
sui client faucet
```

2. Get **Object** of this address:
```sh
sui client objects <your_address>
```

Example result:
```sh
╭───────────────────────────────────────────────────────────────────────────────────────╮
│ ╭────────────┬──────────────────────────────────────────────────────────────────────╮ │
│ │ objectId   │  0x32f1011f65529cbf5b91cccaf04d334f044bf7e9be485058bxxxxxxxxxxxx  │ │
│ │ version    │  7                                                                   │ │
│ │ digest     │  TC2QoMLPHF5IlinAJa9pG1snW2AcVN2qIy+xxxxxxx=                        │ │
│ │ objectType │  0x0000..0002::coin::Coin                                            │ │
│ ╰────────────┴──────────────────────────────────────────────────────────────────────╯ │
╰───────────────────────────────────────────────────────────────────────────────────────╯
```

3. Check your balance from the current address 
```sh
sui client balance
```

Example result:
```sh
╭────────────────────────────────────────╮
│ Balance of coins owned by this address │
├────────────────────────────────────────┤
│ ╭─────────────────────────────────╮    │
│ │ coin  balance (raw)  balance    │    │
│ ├─────────────────────────────────┤    │
│ │ Sui   1000000000     1.00 SUI   │    │
│ ╰─────────────────────────────────╯    │
╰────────────────────────────────────────╯
```

5. Create the **hello_move** package
```sh
cd ~/mover-nhoc20170861/mover/nhoc20170861/code/task1
sui move new hello_move
```
- The structure of the `hello_move` package is as follows:
```sh
.
├── Move.toml
├── sources
│   └── hello_move.move
└── tests
    └── hello_move_tests.move
```
- Modify file [`hello_move.move`](task1/hello_move/sources/hello_move.move) and write your source code 

6. Build your **hello_move** package
```sh
cd mover/nhoc20170861/code/task1/hello_move 
# build this package
sui move build
```

Output:
```sh
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING hello_move
```

7. Publish your package and test it
- Publish the package (*I publish to the testnet*):
```sh
sui client publish --gas-budget 100000000
```
> [!NOTE]  
> I publish to the **testnet** network

- Test this package:

```sh
sui client call --module hello_move --function hello_move --package 0x06944b1770e35c797fb2d488b066bef5c5c16b77a4ebfd900a9053e18b6e56a5 --gas-budget 100000000
```

- Check the new Object:
```sh
sui client object 0x92f4849670a7a238ed322729876d1d3fb4f848c1c88ab1bf7b967601f204ad94
```

Ouput:

```sh
╭───────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ objectId      │  0x92f4849670a7a238ed322729876d1d3fb4f848c1c88ab1bf7b967601f204ad94                                                          │
│ version       │  289573222                                                                                                                   │
│ digest        │  Ffwf6ihZafT4jhBmj5hoCysQvnBosaxPPm2jatYwggcf                                                                                │
│ objType       │  0x06944b1770e35c797fb2d488b066bef5c5c16b77a4ebfd900a9053e18b6e56a5::hello_move::Hello_nhoc20170861                          │
│ owner         │ ╭──────────────┬──────────────────────────────────────────────────────────────────────╮                                      │
│               │ │ AddressOwner │  0xe5209f6d7c0ff44257cb20051438748c96826e6b2acf4f0b0fa7280923e96c9b  │                                      │
│               │ ╰──────────────┴──────────────────────────────────────────────────────────────────────╯                                      │
│ prevTx        │  GsruJqbAF4WxxoH6fDbawrFknjWzj7P7M8nWPacmJyAz                                                                                │
│ storageRebate │  1664400                                                                                                                     │
│ content       │ ╭───────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────╮ │
│               │ │ dataType          │  moveObject                                                                                          │ │
│               │ │ type              │  0x06944b1770e35c797fb2d488b066bef5c5c16b77a4ebfd900a9053e18b6e56a5::hello_move::Hello_nhoc20170861  │ │
│               │ │ hasPublicTransfer │  true                                                                                                │ │
│               │ │ fields            │ ╭──────┬───────────────────────────────────────────────────────────────────────────────╮             │ │
│               │ │                   │ │ id   │ ╭────┬──────────────────────────────────────────────────────────────────────╮ │             │ │
│               │ │                   │ │      │ │ id │  0x92f4849670a7a238ed322729876d1d3fb4f848c1c88ab1bf7b967601f204ad94  │ │             │ │
│               │ │                   │ │      │ ╰────┴──────────────────────────────────────────────────────────────────────╯ │             │ │
│               │ │                   │ │ text │  Hello World Sui! I'm nhoc20170861                                            │             │ │
│               │ │                   │ ╰──────┴───────────────────────────────────────────────────────────────────────────────╯             │ │
│               │ ╰───────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────╯ │
╰───────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

8. How to run unit test for the package
- Write logic test as the file [hello_move_tests.move](task1/hello_move/tests/hello_move_tests.move)
- Test smart contract and check output:

```sh
☁  hello_move [main] ⚡  sui move test
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING hello_move
Running Move unit tests
[debug] "Hello World Sui! I'm nhoc20170861"
[ PASS    ] hello_move::hello_move_tests::test_hello_move
Test result: OK. Total tests: 1; passed: 1; failed: 0
```