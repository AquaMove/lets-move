/* eslint-disable @typescript-eslint/no-explicit-any */
import { useCurrentAccount, useCurrentWallet, useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import React, { useState } from 'react';
import { toast } from 'react-toastify';
import { BiLoaderAlt } from 'react-icons/bi';
import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { useEffect } from 'react';

const faucetPackageId = process.env.NEXT_PUBLIC_FAUCET_COIN_PACKAGE_ID ?? '';
const faucetCoinId = process.env.NEXT_PUBLIC_FAUCET_COIN_ID ?? '';

const FaucetToken = () => {
    const { connectionStatus } = useCurrentWallet();
    const account = useCurrentAccount();
    const [isFaucetLoading, setIsFaucetLoading] = useState(false);
    const { mutate: signAndExecuteTransaction } = useSignAndExecuteTransaction();
    const [suiClient, setSuiClient] = useState<SuiClient | null>(null);
    useEffect(() => {
        const client = new SuiClient({ url: getFullnodeUrl('testnet') });
        setSuiClient(client);
    }, []);

    const handleFaucet = async () => {

        if (!account?.address || !suiClient) {
            toast.error('Please connect your wallet first.');
            return;
        }

        setIsFaucetLoading(true);
        try {
            const txb = new TransactionBlock();
             txb.moveCall({
                target: `${faucetPackageId}::faucet_coin::mint_and_transfer`,
                 arguments: [
                    txb.pure(faucetCoinId)
                 ],
            });
            const serializedTransaction = await txb.serialize();

             signAndExecuteTransaction(
                 {
                     transaction: serializedTransaction,
                 },
                {
                     onSuccess: (result) => {
                        toast.success('Faucet successful!');
                        console.log(result)
                    },
                     onError: (error) => {
                        toast.error(`Faucet failed: ${error.message}`);
                         console.error('Transaction Error:', error);
                     },
                     onSettled: () => {
                         setIsFaucetLoading(false);
                     }
                 },
             )
        } catch (e: any) {
             toast.error(`Transaction failed: ${e.message}`);
            setIsFaucetLoading(false);
           console.error('Transaction Error:', e);
        }
    };

    return (
        <div className="flex items-center justify-center p-4 relative overflow-hidden h-full bg-gray-100">
            <div className="w-full max-w-md bg-white rounded-xl shadow-lg p-6 border border-gray-200">
                <h2 className="text-2xl font-semibold mb-6 text-gray-800 text-center">
                    Faucet Tokens
                 <span className="absolute bottom-[-1px] left-1/2 transform -translate-x-1/2 w-10 h-[3px] bg-gradient-to-r from-purple-500 to-blue-500 rounded-full"></span>
                </h2>
                {connectionStatus !== 'connected' && (
                    <p className="text-center text-red-500 mb-5">Please connect your wallet</p>
                )}

                {connectionStatus === 'connected' && (
                    <p className="text-center text-gray-500 mb-5">Connected Account: <span className='font-semibold text-gray-700'>{account?.address.substring(0, 6)}...{account?.address.substring(account?.address.length - 4)}</span></p>
                )}


                  <div className="flex items-center justify-between mt-4">
                         <span className='font-medium text-gray-700'>FAUCET COIN</span>
                         <button
                           className={`bg-gradient-to-r from-purple-500 to-blue-500 text-white font-semibold py-2 px-4 rounded-xl hover:opacity-90 transition flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed`}
                            onClick={handleFaucet}
                            disabled={isFaucetLoading}
                         >
                              {isFaucetLoading ? <><BiLoaderAlt className='animate-spin mr-2'/> Faucet...</> : 'Faucet'}
                        </button>
                   </div>
             </div>
        </div>
    )
}

export default FaucetToken;