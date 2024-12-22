## Command used

```bash
# Create new package
sui move new task1

# Build the project
sui move build

# Run the test
sui move test

# Import seed phrase from sui wallet
sui keytool import <SEED_PHRASE> ed25519 "m/44'/784'/0'/0'/0'"

# Check if address is active
sui client addresses

# Switch to the desired address
sui client switch --address <ALIAS_NAME / ADDRESS>

# Request faucet
sui client faucet --address <ADDRESS>

# Publish the package
sui client publish
```