import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        txb.transferObjects([coin], '0xd5c70bc827a053b6bfda34cccf658413826cecf20b1bbc13820c004da9d69317');



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
