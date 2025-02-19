import {
  useCurrentAccount,
  useSignAndExecuteTransaction,
} from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { Flex } from "@radix-ui/themes";
import { toast } from "react-toastify";
import { FAUCET_COIN_CAP_KEEPER } from "../constants";
import { useNetworkVariable } from "../networkConfig";
import { getExplorerUrl } from "../utils/format";

const CoinButton = () => {
  const currentAccount = useCurrentAccount();
  const { mutateAsync: signAndExecuteTransaction } =
    useSignAndExecuteTransaction();
  const faucetCoinPackageId = useNetworkVariable("faucetCoinPackageId");

  const handleClick = async () => {
    if (!currentAccount || !faucetCoinPackageId) {
      return;
    }
    const tx = new Transaction();
    tx.moveCall({
      target: `${faucetCoinPackageId}::faucet_coin::mint_token`,
      arguments: [
        tx.object(FAUCET_COIN_CAP_KEEPER),
        // tx.pure.u64(1_000_000_000),
        // tx.object(currentAccount.address),
      ],
    });
    toast.promise(
      signAndExecuteTransaction(
        {
          transaction: tx,
        },
        {
          onSuccess: ({ digest }) => {
            console.log("executed transaction", digest);
          },
        },
      ),
      {
        pending: "Minting 1000 Faucet Coin to your account",
        success: {
          render: ({ data: { digest } }: { data: { digest: string } }) => {
            return (
              <Flex direction={"column"}>
                Mint 1000 faucet coin successfully{" "}
                <a href={getExplorerUrl(digest)} target="_blank">
                  {getExplorerUrl(digest)}
                </a>
              </Flex>
            );
          },
        },
        error: "Failed to mint faucet coin",
      },
    );
  };

  return (
    <button
      className="bg-gradient-to-r from-blue-300 via-brown-500 to-purple-500 text-white font-bold py-2 px-4 rounded"
      onClick={handleClick}
    >
      Mint Token
    </button>
  );
};

export default CoinButton;
