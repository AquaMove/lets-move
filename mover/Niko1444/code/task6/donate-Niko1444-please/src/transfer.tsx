import { useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";
import "./styles/SendSui.css";

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();
  const [txDigest, setTxDigest] = useState("");

  function sendMessage() {
    const txb = new Transaction();
    const coin = txb.splitCoins(txb.gas, [144400000]);
    txb.transferObjects(
      [coin],
      "0xde96ac07b26aa9688644077174a30b98b3487a35032af0df999bd892a1fb4f12",
    );

    signAndExecuteTransactionBlock({
      transaction: txb,
    })
      .then(async (result) => {
        alert("SUI donated successfully!");
        setTxDigest(result.digest);
      })
      .catch((error) => {
        alert("Transaction failed: " + error.message);
        setTxDigest("");
      });
  }

  return (
    <div className="send-sui-container">
      <h2 className="send-sui-title">Donate SUI</h2>
      <button
        onClick={() => sendMessage()}
        className="send-sui-button pixel-borders"
      >
        Donate!
      </button>
      {txDigest && (
        <div className="mt-4 p-2 bg-green-100 border-2 border-green-600 rounded text-xs break-all">
          <p className="digest mb-1">Transaction Digest:</p>
          <p className="digest-child mb-1">{txDigest}</p>
        </div>
      )}
    </div>
  );
}
