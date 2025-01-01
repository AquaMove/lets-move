# https://docs.sui.io/references/cli/client
network:
	sui client envs 
version:
	sui --version
address: # https://docs.sui.io/references/cli/cheatsheet
	sui client address
new-address:
	sui client new-address ed25519
balance:
	sui client balance
move-build:
	sui move build
test:
	sui move test
client-objects:
	sui client objects
faucet:
	sui client faucet
# https://docs.sui.io/guides/developer/first-app/publish
publish:
	sui client publish

# https://docs.sui.io/references/cli/cheatsheet#executing-transactions
# │ Published Objects:                                                                               │
# │  ┌──                                                                                             │
# │  │ PackageID: 0x145a559fe7127f1d908a91a2eca93efdb865849ca6e86afefbf62a6c453fa76c                 │
# │  │ Version: 1                                                                                    │
# │  │ Digest: GuKLuED88MVxgyhGfsa46cqo2LZPvaozJ5FhYTzU69Rj                                          │
# │  │ Modules: longphu                                                                              │
# │  └──                                                                                             │
# ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
call-package:
	sui client call --package 0x145a559fe7127f1d908a91a2eca93efdb865849ca6e86afefbf62a6c453fa76c --module longphu --function say_hello

view-object:
	sui client object 0x61a19ec0244dacd834e0dbeab725b4d014962c879b2db69393050be549002591

keytool:
	sui keytool list

export-private-key:
	sui keytool export --key-identity naughty-idocrase

mint-my-coin:
	sui client call --package 0xcb3af9597bca8d4cfd1f9995cce3fec8ffed9ed3d589526096ce441de5b6efb7 --module my_coin --function mint --args 0x01e060aca9d96cb9a710ae5c76be193b5b7d79968d7bebb7cb9a8c6838b5fbed 1000000000 0x052f5a900488ef4a6c130e395ea6c10d1b0d73e12adb7da43dfd5ef47ecd5a6e

# ObjectType: 0x2::coin::TreasuryCap<0xcb3af9597bca8d4cfd1f9995cce3fec8ffed9ed3d589526096ce441de5b6efb7::my_coin::MY_COIN>

mint-faucet-coin:
	sui client call --package 0x224f8dc5ce2b50aa05b1a2f7f3bc837c6488303482ac521ac0bbbe821277870b --module faucet_coin --function mint --args 0xe986705f1fc23a91ec33f829899b930d376179a424c5771488d9337553d434b9 1000000000 0x052f5a900488ef4a6c130e395ea6c10d1b0d73e12adb7da43dfd5ef47ecd5a6e
	
# ObjectID:0xe986705f1fc23a91ec33f829899b930d376179a424c5771488d9337553d434b9
# ObjectType: 0x224f8dc5ce2b50aa05b1a2f7f3bc837c6488303482ac521ac0bbbe821277870b::faucet_coin::TreasuryCapKeeper 