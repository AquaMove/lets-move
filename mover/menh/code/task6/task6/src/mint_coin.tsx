import {
  useSignAndExecuteTransaction,
  useCurrentAccount,
} from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";

export function mint_coin() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();

  function sendMessage() {
    const txb = new Transaction();

    txb.moveCall({
      target:
        "0x4b40a1616de5132bca83ee5eb14fe8d4c3e7091288474edf0832df4c7a9da32c::faucet_coin::mint_token",
      arguments: [
        txb.pure.string(
          "0x403fc20f267a7fd311766c07ec4ac60bc4af740f8595976d9e8ee4ddcf949cdf",
        ),
      ],
    });
    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert("Sui sent successfully");
    });
  }

  return <button onClick={() => sendMessage()}>Send me Sui!</button>;
}
