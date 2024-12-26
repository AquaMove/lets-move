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