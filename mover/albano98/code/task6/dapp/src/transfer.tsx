import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        txb.transferObjects([coin], '0xa2f8b4396fc1cf5b5ef5b89393c23d80e4ace73f8cb3e659bd3cf45804143e8e');



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
