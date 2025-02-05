import { Button, Flex } from "@radix-ui/themes";
import React from "react";
import { SWAP_COINS, SWAP_PACKAGE_ID } from "../utils/constants";
import {
  useCurrentAccount,
  useSignAndExecuteTransaction,
  useSuiClientQuery,
} from "@mysten/dapp-kit";
import { toast } from "react-toastify";
import { Transaction } from "@mysten/sui/transactions";
import { getExplorerUrl } from "../utils/network";
type Props = {
  from: string;
  to: string;
  amount: number;
};
const SwapButton: React.FC<Props> = ({ from, to, amount }) => {
  const { mutateAsync: signAndExecuteTransaction } =
    useSignAndExecuteTransaction();
  const account = useCurrentAccount();
  const fromCoin = SWAP_COINS[from];

  const toCoin = SWAP_COINS[to];
  console.log("fromCoin", fromCoin);
  console.log("toCoin", toCoin);

  const { data: fromCoinbalance } = useSuiClientQuery(
    "getBalance",
    {
      owner: account?.address as string,
      coinType: fromCoin.type,
    },
    {
      enabled: !!account,
    },
  );

  const { data: fromCoinObjects } = useSuiClientQuery(
    "getOwnedObjects",
    {
      owner: account?.address as string,
      options: {
        showType: true,
        showContent: true,
      },
      filter: {
        MatchAny: [
          {
            StructType: `0x2::coin::Coin<${fromCoin.type}>`,
          },
        ],
      },
    },
    {
      enabled: !!account,
    },
  );
  const handleSwap = () => {
    if (!fromCoinbalance || !fromCoinObjects) {
      toast.error(
        "Error fetching balance or you don't have balance of source coin",
      );
      return;
    }
    if (
      BigInt(fromCoinbalance?.totalBalance) <
      BigInt(amount * 10 ** fromCoin.decimals)
    ) {
      toast.error("Insufficient balance");
      return;
    }

    const tx = new Transaction();
    if (!fromCoinObjects?.data) {
      toast.error("Error fetching coin objects");
      return;
    }

    if (fromCoinObjects?.data.length === 0) {
      toast.error("You don't have any coin to split");
      return;
    }

    const coinToSplit = fromCoinObjects?.data[0];

    // if (fromCoinObjects?.data.length > 1) {
    //  tx.mergeCoins(tx.object(coinToSplit.data?.objectId), fromCoinObjects?.data.slice(1).map(c=>tx.object(c.data?.objectId)));
    // }

    // const coinToSplit = fromCoinObjects?.data.find(c=>c.data?.content?.fields.)
    const coin = tx.splitCoins(tx.object(coinToSplit.data?.objectId!), [
      tx.pure.u64(BigInt(amount * 10 ** fromCoin.decimals)),
    ]);
    // tx.transferObjects([coin], tx.pure.address(account?.address!));

    tx.moveCall({
      target: `${SWAP_PACKAGE_ID}::hongthaipham_swap::${from === "FAUCET_COIN" ? "swap_to_y" : "swap_to_x"}`,
      arguments: [
        tx.object(
          "0x0b00a7fa646c723013e130ad996c2da4a07b87b9ae5e0a69f897a92c6a9bf063",
        ),
        tx.object(coin),
        tx.pure.u64(1),
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
                Split coin successfully{" "}
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
    <>
      <Button onClick={handleSwap} size={"4"}>
        Swap
      </Button>
      <pre>{JSON.stringify(fromCoinObjects, null, 2)}</pre>
    </>
  );
};

export default SwapButton;
