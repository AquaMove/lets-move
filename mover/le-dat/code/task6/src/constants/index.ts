export const SWAP_PACKAGE_ID = "";
export const FAUCET_COIN_CAP_KEEPER =
  "0x32e6c6a53750cadd6303fd5cb6e7548d426b20c5f145d7c0b5dc30195ebbca0e";
export const FAUCET_COIN_PACKAGE_ID: string =
  "0x6bf944f582d9972fbbcbfbdf3c3f4821004953794751d8c2490704a42c36b416";
export const MY_COIN_PACKAGE_ID: string =
  "0x372dcade938776ad18806ba7679e060422e5625a2853fd09de75cf6f92510a44";

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
