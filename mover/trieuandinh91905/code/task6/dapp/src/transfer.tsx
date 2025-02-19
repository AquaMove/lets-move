import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        txb.transferObjects([coin], '0x11288760f4abd23dc41af0c56ebfcd99878fe98e7f4faaa064ef1c513bbff5b3');



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
