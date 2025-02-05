import React, { useState } from 'react';
import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
 
export function SendSui() {
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [Digest, SetDigest] = useState('');
	function sendMessage() {
		const txb = new Transaction();
 
		const coin = txb.splitCoins(txb.gas, [1000]);
		txb.transferObjects([coin], '0xd35f294aa3a96ab6714a5cd97a00a3341da1667a889d76ace88e6784968bf655');
        
		signAndExecuteTransactionBlock({
			transaction: txb,   
		}).then(async (result) => {
			alert('Sui sent successfully');
		});
	}
    return (
        <div>
            <button onClick={() => sendMessage()}>Send me Sui!</button>
            <div>Digest: {Digest}</div>
        </div>
    );
}