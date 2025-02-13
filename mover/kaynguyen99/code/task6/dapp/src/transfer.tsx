import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        txb.transferObjects([coin], '0x142f9618fd6ac4a3ce18d74874661453f7f204a9297a6f8d468b8820b21f0a6f');



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
