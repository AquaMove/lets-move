import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';
 
export function SendSui() {
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [receiver, setReceiver] = useState('');
    const [amount, setAmount] = useState<number>(0);
    const [digest, setDigest] = useState('');
 
	function sendMessage() {
		const txb = new Transaction();
 
		const coin = txb.splitCoins(txb.gas, [amount]);
		txb.transferObjects([coin], receiver);
 
		signAndExecuteTransactionBlock({
			transaction: txb,   
		})
            .then(async (result) => {
                alert('Transaction sent successfully');
                setDigest(result.digest);
            })
            .catch(err => {
                alert("Transaction failed to send");
                console.log(err);
            });
	}
 
	return (
        <div>
            <div>
                <label htmlFor='receiver'>Receiver: </label>
                <input type='text' placeholder='Receiver address' id='receiver' onChange={(e) => setReceiver(e.target.value)}></input>
            </div>

            <div>
                <label htmlFor='amount'>Amount: </label>
                <input type='number' placeholder='Amount of Sui' id='amount' onChange={(e) => setAmount(parseFloat(e.target.value) || 0)}></input>
            </div>



            <button onClick={() => sendMessage()}>Send me Sui!</button>

            <div>
                Transaction digest: {digest}
            </div>
        </div>
    );
}