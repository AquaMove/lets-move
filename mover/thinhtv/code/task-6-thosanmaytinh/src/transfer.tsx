import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

export function SendSui() {
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [digest, SetDigest] = useState('');

	function sendMessage() {
		const txb = new Transaction();

		const coin = txb.splitCoins(txb.gas, [10]);
		txb.transferObjects([coin], '0xb2a1cb6a7f1d1d069e598ee66c50219bdfd5a6b8373e8a4567f145319b8e8eb5');

        txb.moveCall({
            target: '0x22099d3ec91a0be52528ce4b58c387f194e4cf4fb3c0cc778f4a28cdef21afd8::hello::say_hello_thinhtv'
        })

		signAndExecuteTransactionBlock({
			transaction: txb,   
		}).then(async (result) => {
			alert('Sui sent successfully');
            SetDigest(result.digest);
		});
	}

	return (
        <div>
            <button class="btn btn-primary"  onClick={sendMessage}>Send Sui</button>
            {digest && <p>Transaction digest: {digest}</p>}
        </div>
    )
}