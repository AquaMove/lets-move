import { useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";

export function SendSui() {
  const [digest, setDigest] = useState("");
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [1000000000]);
    txb.transferObjects(
      [coin],
      "0x948c281ac0727c6d57f8b09a6a15789a215e302239de666fd7698e2531522611",
    );

    txb.moveCall({
      target:
        "0x5123d46b7c489c91d8d42fe53d76526d95016cff4dac80beff12c65e6b404b98::faucet_coin::mint_token",
      arguments: [
        txb.object(
          "0x98feb91c55c337be9ef202f64e1ad1103f3d05965e0b2155f207af2ae1fb6ba3",
        ),
      ],
    });

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert("Sui sent successfully");
      setDigest(result.digest);
    });
  }

  return (
    <div>
      <button onClick={() => sendMessage()}>Send me Sui!</button>
      <div>Digest: {digest}</div>
    </div>
  );
}
