import { getFullnodeUrl } from "@mysten/sui/client";
import { createNetworkConfig } from "@mysten/dapp-kit";
import { FAUCET_COIN_PACKAGE_ID, SWAP_PACKAGE_ID } from "./constants";

const { networkConfig, useNetworkVariable, useNetworkVariables } =
  createNetworkConfig({
    devnet: {
      url: getFullnodeUrl("devnet"),
      variables: {
        swapPackageId: "",
        faucetCoinPackageId: "",
      },
    },
    testnet: {
      url: getFullnodeUrl("testnet"),
      variables: {
        swapPackageId: SWAP_PACKAGE_ID,
        faucetCoinPackageId: FAUCET_COIN_PACKAGE_ID,
      },
    },
    mainnet: {
      url: getFullnodeUrl("mainnet"),
      variables: {
        swapPackageId: "",
        faucetCoinPackageId: "",
      },
    },
  });

export { useNetworkVariable, useNetworkVariables, networkConfig };
