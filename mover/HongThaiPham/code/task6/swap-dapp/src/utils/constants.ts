export const SWAP_PACKAGE_ID =
  "0x1caa1c8b0474bfd47d359d3a6bc4138d7f25dd06f8f024fec5f68ec2758c82fe";
export const FAUCET_COIN_PACKAGE_ID =
  "0x161df9d64fcfde1583a163db235ce7e29b55029eef5225179a413d146c5fa5cb";
export const MY_COIN_PACKAGE_ID =
  "0xae09bec9ad5d96e3c90254794fd35108b76a06be877045ef825a55f79be1f357";

export const FAUCET_COIN_CAP_KEEPER =
  "0x423422997fc6add02bb97e7f5a89fb6edff8c2137f84ebe79fbcca02bd8066f1";

export const SWAP_COINS: Record<
  string,
  { name: string; type: string; decimals: number }
> = {
  MY_COIN: {
    name: "MY COIN",
    type: `${MY_COIN_PACKAGE_ID}::my_coin::MY_COIN`,
    decimals: 6,
  },
  FAUCET_COIN: {
    name: "FAUCET COIN",
    type: `${FAUCET_COIN_PACKAGE_ID}::faucet_coin::FAUCET_COIN`,
    decimals: 6,
  },
};
