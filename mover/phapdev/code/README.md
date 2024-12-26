# Complete Deployment of Two Coin Contracts

- Onchain network: Sui Testnet

## Requirements

- Complete the study of Coin-related concepts.
- Deploy `My Coin` on mainnet.
- Deploy `Faucet Coin` on mainnet.
- Submit the `package id` for both `My Coin` and `Faucet Coin` contracts.
- Send `My Coin` to the address `0xa9ddd77d41119bdcbab0f5c4d18bf15e65034607afc5a296865f640e0d33d958`
- Ensure that `Faucet Coin` is minted using at least two different addresses.

## Learning Points

1. Understand the Coin protocol and how to create a Coin.
2. Differentiate between exclusive ownership and shared ownership.
3. Respect shared ownership, as permissions are shared.
    - `public_transfer`: Exclusive minting permission.
    - `public_share_object`: Shared minting permission.

## Task Guide
- `Faucet Coin`: A Coin that anyone can mint.
- `My Coin`: A Coin that can only be minted by specific addresses.