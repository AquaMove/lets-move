import {useSignAndExecuteTransaction} from '@mysten/dapp-kit';
import {Transaction} from '@mysten/sui/transactions';
import {useState} from 'react';

export function SendSui() {
  const {mutateAsync: signAndExecuteTransactionBlock} = useSignAndExecuteTransaction();
  let [Digest, SetDigest] = useState('');

  function sendMessage() {
    const txb = new Transaction();
    const coin = txb.splitCoins(txb.gas, [100]);
    txb.transferObjects([coin], '0x3fd9d7e5854230700f9e70f2bd7750772136f516e7df77992d0bd5c9004b5fd6');
    txb.moveCall({target: '0xfc676b1c37c626b4a8e373611b594b66a5b6ac0223d0b37e0117decd20affbbe::hello_move::shoutout_vdhan'});

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert('Sui sent successfully');
      SetDigest(result.digest);
    });
  }

  return (
    <div>
      <button onClick={() => sendMessage()}>Send me Sui!</button>
      <div>Digest: {Digest}</div>
    </div>
  )
}