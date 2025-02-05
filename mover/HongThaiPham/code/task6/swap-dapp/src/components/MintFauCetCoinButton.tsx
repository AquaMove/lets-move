import {
  useCurrentAccount,
  useSignAndExecuteTransaction,
} from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { MagicWandIcon } from "@radix-ui/react-icons";
import { Button, Flex } from "@radix-ui/themes";
import { useNetworkVariable } from "../networkConfig";
import { FAUCET_COIN_CAP_KEEPER } from "../utils/constants";
import { toast } from "react-toastify";
import { getExplorerUrl } from "../utils/network";

const MintFauCetCoinButton = () => {
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
      target: `${faucetCoinPackageId}::faucet_coin::mint`,
      arguments: [
        tx.object(FAUCET_COIN_CAP_KEEPER),
        tx.pure.u64(1_000_000_000),
        tx.object(currentAccount.address),
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
          render: ({ data: { digest } }) => {
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
        error: "Mint Faucet Coin failed",
      },
    );
  };
  return (
    <Button onClick={handleClick}>
      <MagicWandIcon />
      Mint Faucet Coin
    </Button>
  );
};

export default MintFauCetCoinButton;
