import {
  useSignAndExecuteTransaction,
  useCurrentAccount,
} from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();

  const [Digest, setDigest] = useState("");

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [10]);
    txb.transferObjects(
      [coin],
      "0x915c2d19ee5fde257693f25e6c2cabb04c25e7ae03932817d52e122258c88ddb",
    );

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
      <div>Digest: {Digest}</div>
    </div>
  );
}
