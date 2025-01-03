import { ConnectButton, useCurrentAccount,  useSuiClientQuery, useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";
import { BcsType, bcs } from "@mysten/sui/bcs";
export function Mint_nft(){
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [digest, setDigest] = useState('');
    function mint(){
        // function encodeVectorU8(value) {
        //     return bcs.serialize('vector<u8>', Array.from(value)).toBytes();
        // }
        function prepareVector(value: string) {
            return new Uint8Array(new TextEncoder().encode(value));
        }
        const PackageId = '0x117d6c9d7700bf916838f8162afad76bd81d5c845ac5fc94e49c9e37319dcba1';
        const moduleName  = 'my_nft';
        const functionName = 'mint_NFT';
    
        const name = 'Bau Troi it sao';
        const url = 'https://cover-talk.zadn.vn/e/c/0/3/4/2deeae676fa53114abad00c3c1ee0d1f.jpg';
        const link_image = 'https://cover-talk.zadn.vn/e/c/0/3/4/2deeae676fa53114abad00c3c1ee0d1f.jpg';
        const description = 'NFT for testnet mint';
        const author = 'anhdoo';
    
        const txb = new Transaction();
        txb.setGasBudget(20000000);
        txb.moveCall({
            target:`${PackageId}::${moduleName}::${functionName}`,
            arguments:[
                txb.pure.string('bau troi it sao'),
                txb.pure.string(url),
                txb.pure.string(link_image),
                txb.pure.string(description),
                txb.pure.string(author),
            ],
        })
        signAndExecuteTransactionBlock({
                transaction: txb,   
            }).then(async (result1) => {
                alert('Sui sent successfully');
                setDigest(result1.digest);
            });
    }
	return (
        <div>
        <button onClick={() => mint()}>Mint bocchi NFT</button>
        <br></br>Transaction digest: {digest}
        </div>
    );
}
export function SendSui() {
	const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [digest, setDigest] = useState('');
	function sendMessage() {
		const txb = new Transaction();
 
		const coin = txb.splitCoins(txb.gas, [10]);
		txb.transferObjects([coin], '0xf2b8341fc93d683292ba428dccf83ba443c15ee19b9f0719bdd0a7f75218c926');
        
		signAndExecuteTransactionBlock({
			transaction: txb,   
		}).then(async (result) => {
			alert('Sui sent successfully');
            setDigest(result.digest);
		});
	}
	return (
        <div>
        <button onClick={() => sendMessage()}>Send me Sui!</button>
        <br></br>Transaction digest: {digest}
        </div>
    );
}
export function OwnedObjects() {
	const account = useCurrentAccount()!;
	const { data } = useSuiClientQuery('getOwnedObjects', 
    { owner: account.address });
 
  if (!data){
    return null;
  }
 
	return (
		<ul>
			{data.data.map((object) => (
				<li key={object.data?.objectId}> {object.data?.objectId}</li>
			))}
		</ul>
	);
}
function MyComponent() {
  const account = useCurrentAccount();
  return (
    <div>
			<ConnectButton />
		
      {!account && <div>No account connected</div>}
 
			{account && (
				<div>
					<h2>Current account:</h2>
					<div>Address: {account.address}</div>
                    <div>
                        <h2>Objects you have:</h2>
                        <OwnedObjects /> 
                    </div>
                    <br />
          <SendSui />
            <div><br></br>
                <h2>Click to recive bocchi NFT!!</h2>
            <Mint_nft/>
            </div>
				</div>
			)}
		</div>
  );
}
export default MyComponent;