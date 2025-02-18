import { useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';

interface SendSuiProps {
    digest: string | null;
    setDigest: (digest: string) => void;
}
 
export function SendSui({ digest, setDigest }: SendSuiProps) {
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
	function sendMessage() {
		const txb = new Transaction();
 
		const coin = txb.splitCoins(txb.gas, [1000000]);
		txb.transferObjects([coin], '0xf73ba580489ff35889382352bdbe8d1a684cd7a58859530164398e55dde6fedc');
 
		signAndExecuteTransactionBlock({
			transaction: txb,   
		}).then(async (result) => {
            setDigest(result.digest);
			alert('Sui sent successfully' + "\nDigest: " + result.digest);
		});
	}
	return <button className="bg-blue-500 text-white px-4 py-3 rounded-md mr-2" onClick={() => sendMessage()}>Send me Sui!</button>;
}