import { Transaction } from '@mysten/sui/transactions';
import {
  ConnectButton,
  useCurrentAccount,
  useSignTransaction,
  useSuiClient,
} from '@mysten/dapp-kit';
import { useState } from 'react';

function MyComponent() {
  const { mutateAsync: signTransaction } = useSignTransaction();
  const [signature, setSignature] = useState('');
  const client = useSuiClient();
  const currentAccount = useCurrentAccount();

  return (
    <div style={{ padding: 20 }}>
      <ConnectButton />
      {currentAccount && (
        <>
          <div>
            <button
              onClick={async () => {
                const txb = new Transaction();

                const [coin] = txb.splitCoins(txb.gas, [100]);
      
                // transfer the split coin to a specific address
                txb.transferObjects([coin], '0xc981b806b59c0576c1b8af41cb0d56c1c23c2d88e6e108ab6a5a63daa93ff7f4');
                const { bytes, signature } = await signTransaction({
                  transaction: txb,
                  chain: 'sui:testnet',
                });

                const executeResult = await client.executeTransactionBlock({
                  transactionBlock: bytes,
                  signature,
                  options: {
                    showRawEffects: true,
                  },
                });

                console.log(executeResult);
                setSignature(executeResult.digest)
              }}
            >
              Sign transaction
            </button>
          </div>
          <div>Signature: {signature}</div>
        </>
      )}
    </div>
  );
}

export default MyComponent;