import { useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();
  const [digest, setDigest] = useState("");

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [100]);
    txb.transferObjects(
      [coin],
      "0x7a84b64fb8b9aa90e99d7bb40db1de3ab88b9d9cd07f3e328dc50d4e7c860b95",
    );

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert("Sui sent successfully");
      setDigest(result.digest);
    });
  }

  return (
    <div className="">
      <button onClick={() => sendMessage()}>Send me Sui!</button>;
      <div>{digest}</div>
    </div>
  );
}
