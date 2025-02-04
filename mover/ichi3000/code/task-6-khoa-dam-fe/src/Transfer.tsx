


import { useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions'
import { Button } from '@radix-ui/themes';
import { useState } from 'react';

export const Transfer = () => {

    const { mutateAsync: useSignAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const [distgest, SetDigest] = useState<string>("");

    const [address, setAddress] = useState<string>("");

    function sendMessage() {
        const txb = new Transaction();

        const coin = txb.splitCoins(txb.gas, [100]);
        if (validateAddress(address)) {
            useSignAndExecuteTransactionBlock({
                transaction: txb,
            }).then(async (result) => {
                alert('Sui sent successfully');
                SetDigest(result.digest);
            });
        } else {
            alert("Invalid Address");
            return;
        }


    }

    function validateAddress(address: string) {
        if (!address || !/^0x[a-fA-F0-9]{64}$/.test(address)) {
            return false;
        }
        return true;
    }


    return (
        <div>
            <input
                type="text"
                placeholder='Enter recipient address'
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                style={{ marginBottom: '10px', padding: '5px' }}
            />
            {address != "" ?
                (
                    <div><Button onClick={() => sendMessage()}> Send me Sui!</Button>
                        <div>
                            <h1>Disgest:</h1> {distgest}
                        </div>
                    </div>
                )
                : <p>Please enter a valid address to enable the button</p>}
        </div>
    )
}
