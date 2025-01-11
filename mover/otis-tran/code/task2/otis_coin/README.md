# Minting Coins with Sui CLI

This document explains how to use the Sui client to mint coins using the `mint` function from the `otis_coin` module.

## Command:
```bash
sui client call \
  --package 0xab3aee4bd220622bc38d4d6f2c356006e32285ce981ede74adf618fc8bcb2b23 \
  --module otis_coin \
  --function mint \
  --args 0x1275ddfa39ca95d946e4d318f627dfc31aa534af7a836577b0ddcf7b14a9d075 400000 0xaebd8a3bc80ea711937bf1831cd5a97b6c166d591594cf87d6338ecd3f1a60fb
```

### Explanation of Parameters:
- **`--package`**: `0xab3aee4bd220622bc38d4d6f2c356006e32285ce981ede74adf618fc8bcb2b23`  
  This is the Package ID of the `otis_coin` package deployed on the Sui blockchain.

- **`--module`**: `otis_coin`  
  This specifies the module within the package that contains the `mint` function.

- **`--function`**: `mint`  
  The function to call in the `otis_coin` module to mint new coins.

- **`--args`**:  
  - `0x1275ddfa39ca95d946e4d318f627dfc31aa534af7a836577b0ddcf7b14a9d075`  
    This is the TreasuryCap object ID required for minting.
  - `400000`  
    The amount of coins to mint.
  - `0xaebd8a3bc80ea711937bf1831cd5a97b6c166d591594cf87d6338ecd3f1a60fb`  
    The recipient's Sui address that will receive the minted coins.
