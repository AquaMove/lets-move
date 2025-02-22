import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        txb.transferObjects([coin], '0x702a6467678e15e4a70633c031bcef6d43589b16db000064af20f19a84b61220');



        signAndExecuteTransactionBlock({
            transaction: txb,
        }).then(async (result) => {
            alert('Sui sent successfully');
            SetDigest(result.digest);
        });
    }

    return (
        <div>{
            <div>
                <button onClick={() => sendMessage()}>Send me Sui!</button>
                <div>Digest: {Digest}</div>
            </div>
        }</div>
    );
}
