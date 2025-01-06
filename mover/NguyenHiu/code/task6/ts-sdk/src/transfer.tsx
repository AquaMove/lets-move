import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useState } from 'react';

const LETTER_PACKAGE_ID = '0xc242f9760180c0f5bb3539173b62a6b49b47c7c2abafcbd3427b70d7bda2efa4';

export function SendSui() {
    const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();
    const account = useCurrentAccount();
    const [Digest, SetDigest] = useState('');

    function sendMessage() {
        const txb = new Transaction();

        // Split 0.1 SUI
        const coin = txb.splitCoins(txb.gas, [100000000]);

        // Transfer 0.1 SUI 
        txb.transferObjects([coin], '0x73017e8dc67f34caa5b27d4841516bfdb1fac14a5a7151b58c74a7d6820f167e');

        // Get the current timestamp
        const current_time = new Date();
        console.log(`Current time: ${current_time.valueOf()}`);

        // Send a thank you letter
        // This module is defined in the "../letter" folder
        // The supporter sends to himself a thank you letter :D
        txb.moveCall({
            package: LETTER_PACKAGE_ID,
            module: 'letter',
            function: 'send_a_letter',
            arguments: [
                txb.pure.string("Thank you letter"),
                txb.pure.string("Dear my friend, I am very grateful for your support. I hope you have a great day!"),
                txb.pure.address(account?.address || ""),
                txb.pure.u64(current_time.valueOf())
            ]
        });

        signAndExecuteTransactionBlock({
            transaction: txb,
        }).then(async (result) => {
            alert('Sui sent successfully');
            SetDigest(result.digest);
        });
    }

    return (
        <div>
            {
                <div>
                    <button className='buy-coffee' onClick={() => sendMessage()}>Buy Me a Coffee</button>
                    {
                        Digest && <div style={{ marginTop: '20px' }}>Transaction digest: <a target="_blank" href={`https://testnet.suivision.xyz/txblock/${Digest}`}>{Digest}</a></div>
                    }
                </div>
            }
        </div>
    )
}