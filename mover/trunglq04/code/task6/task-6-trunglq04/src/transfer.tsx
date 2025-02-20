import {
  useSignAndExecuteTransaction,
  useCurrentAccount,
} from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();
  const [Digest, SetDigest] = useState("");

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [10]);
    txb.transferObjects(
      [coin],
      "0xbc5049e7435b74e526e13346cbb169a6ab6a6bd3393b1f2bde632dd5c69c2dbc",
    );

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert("Sui sent successfully");
      SetDigest(result.digest);
    });
  }

  return (
    <div>
      {
        <div>
          <button onClick={() => sendMessage()}>Send me Sui!</button>
          <div>Digest: {Digest}</div>
        </div>
      }
    </div>
  );
}
