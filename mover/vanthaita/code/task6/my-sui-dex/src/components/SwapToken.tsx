/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
'use client';

import React, { useEffect, useState } from 'react';
import { useCurrentAccount, useCurrentWallet, useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import { toast } from 'react-toastify';
import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client';
import PoolInfo from './PoolInfo';
import { useCoinBalances, usePoolData } from '@/hook/useSwapToken';
import { calculateToAmount } from '@/utils/utils';
import SwapForm from './SwapFrom';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { BiLoaderAlt } from 'react-icons/bi';
import { FaCoins, FaExchangeAlt, FaGasPump } from 'react-icons/fa';


const packageObjectId = process.env.NEXT_PUBLIC_SUI_PACKAGE_ID ?? '';
const faucetCoinType = process.env.NEXT_PUBLIC_FAUCET_COIN_TYPE ?? '';
const myCoinType = process.env.NEXT_PUBLIC_MY_COIN_TYPE ?? '';
const poolObjectId = process.env.NEXT_PUBLIC_POOL_OBJECT_ID ?? '';


export default function SwapToken() {
    const { connectionStatus } = useCurrentWallet();
    const account = useCurrentAccount();
    const [fromToken, setFromToken] = useState('FAUCET_COIN');
    const [toToken, setToToken] = useState('MY_COIN');
    const [fromAmount, setFromAmount] = useState('');
    const [toAmount, setToAmount] = useState('Calculated');
    const [isTransactionLoading, setIsTransactionLoading] = useState(false);
    const [gasEstimate, setGasEstimate] = useState<number | null>(null);
    const [slippage, setSlippage] = useState(0.005);
    const [suiClient, setSuiClient] = useState<SuiClient | null>(null);
    const { mutate: signAndExecuteTransaction } = useSignAndExecuteTransaction();
     const [poolRefreshKey, setPoolRefreshKey] = useState(0);
    const { poolInfo, isPoolLoading, refetch: refetchPoolData } = usePoolData(poolObjectId, suiClient, poolRefreshKey);
      const [balancesRefreshKey, setBalancesRefreshKey] = useState(0);
    const { faucetCoinBalance, myCoinBalance, isBalancesLoading, refetch: refetchBalances } = useCoinBalances(account?.address, suiClient, faucetCoinType, myCoinType, balancesRefreshKey);
    
    useEffect(() => {
        const client = new SuiClient({ url: getFullnodeUrl('testnet') });
        setSuiClient(client);
    }, []);

    const handleSwap = async () => {
        if (!account?.address || !suiClient) {
            toast.error('Please connect your wallet first.');
            return;
        }

        if (!fromAmount || isNaN(Number(fromAmount)) || Number(fromAmount) <= 0) {
            toast.error('Please enter a valid amount to swap.');
            return;
        }
        setIsTransactionLoading(true);

        try {
            const amount = Math.floor(Number(fromAmount) * 1000000000);
            const txb = new TransactionBlock();

            let coinTypeToUse;
            if (fromToken === 'FAUCET_COIN') {
                coinTypeToUse = faucetCoinType;
            } else if (fromToken === 'MY_COIN') {
                coinTypeToUse = myCoinType;
            } else {
                toast.error('Invalid from token selected');
                setIsTransactionLoading(false);
                return;
            }

            const coins = await suiClient.getCoins({
                owner: account.address,
                coinType: coinTypeToUse
            });

            if (!coins || coins.data.length === 0) {
                toast.error('No coins available for the selected from token.');
                setIsTransactionLoading(false);
                return;
            }
            const coin = coins.data[0];

            if (!coin) {
                toast.error('Coin object is undefined')
                setIsTransactionLoading(false)
                return
            }
            const coinInput = txb.splitCoins(txb.object(coin.coinObjectId), [txb.pure(amount)])

            let targetFunction: `${string}::${string}::${string}`;
            if (fromToken === 'FAUCET_COIN' && toToken === 'MY_COIN') {
                targetFunction = `${packageObjectId}::move_swap::swap_coin_a_to_coin_b`;
            } else if (fromToken === 'MY_COIN' && toToken === 'FAUCET_COIN') {
                targetFunction = `${packageObjectId}::move_swap::swap_coin_b_to_coin_a`;
            } else {
                toast.error('Invalid swap tokens');
                setIsTransactionLoading(false);
                return;
            }

            txb.moveCall({
                target: targetFunction,
                arguments: [
                    txb.object(poolObjectId),
                    coinInput,
                ],
            });

            const serializedTransaction = await txb.serialize();

            signAndExecuteTransaction(
                {
                    transaction: serializedTransaction,
                },
                {
                    onSuccess: (result) => {
                        toast.success('Transaction success');
                         setBalancesRefreshKey(prev => prev + 1);
                         setPoolRefreshKey(prev => prev + 1);
                    },
                    onError: (error) => {
                        toast.error(`Transaction failed: ${error.message}`);
                        console.error('Transaction Error:', error);
                    },
                    onSettled: () => {
                        setIsTransactionLoading(false);
                    }
                },
            );


        } catch (e: any) {
            toast.error(`Transaction failed: ${e.message}`);
            setIsTransactionLoading(false);
            console.error('Transaction Error:', e);
        }

    };

    const handleFromTokenChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setFromToken(e.target.value);
        setToToken(e.target.value === 'FAUCET_COIN' ? 'MY_COIN' : 'FAUCET_COIN')
    };

    const handleToTokenChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setToToken(e.target.value);
        setFromToken(e.target.value === 'FAUCET_COIN' ? 'MY_COIN' : 'FAUCET_COIN')
    };

    const handleFromAmountChange = (value: string) => {
        setFromAmount(value);
        setToAmount(calculateToAmount(value, poolInfo, fromToken))
    }


    return (
        <div className="flex items-center justify-center p-4 relative overflow-hidden h-full bg-gray-100">
            <div className="w-full max-w-md bg-white rounded-xl shadow-lg p-6 border border-gray-200">
                <h2 className="text-2xl font-semibold mb-6 text-gray-800 text-center">
                    Swap Tokens
                </h2>
                {connectionStatus !== 'connected' && (
                    <p className="text-center text-red-500 mb-5">Please connect your wallet</p>
                )}

                {connectionStatus === 'connected' && (
                    <p className="text-center text-gray-500 mb-5">Connected Account: <span className='font-semibold text-gray-700'>{account?.address.substring(0, 6)}...{account?.address.substring(account?.address.length - 4)}</span></p>
                )}

                <SwapForm
                    fromToken={fromToken}
                    toToken={toToken}
                    fromAmount={fromAmount}
                    toAmount={toAmount}
                    faucetCoinBalance={faucetCoinBalance}
                    myCoinBalance={myCoinBalance}
                    onFromTokenChange={handleFromTokenChange}
                    onToTokenChange={handleToTokenChange}
                    onFromAmountChange={handleFromAmountChange}
                    isBalancesLoading={isBalancesLoading}
                />

                <PoolInfo
                    isPoolLoading={isPoolLoading}
                    poolInfo={poolInfo}
                />


                <div className="text-gray-600 text-sm mb-4">
                    <div className="flex justify-between py-1 border-t border-gray-200 items-center">
                        <span className="font-medium text-gray-700">Slippage:</span>
                        <span>{slippage * 100}%</span>
                    </div>
                    <div className="flex justify-between py-1 items-center">
                            <span className='flex items-center font-medium text-gray-700'>
                                <FaGasPump className='mr-1' /> Gas Estimate:
                            </span>
                            <span>{gasEstimate ? gasEstimate.toFixed(4) : '0.0000'} SUI</span>
                    </div>
                </div>


                <button
                    className={`w-full bg-gradient-to-r from-purple-500 to-blue-500 text-white font-semibold py-3 rounded-xl hover:opacity-90 transition flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed`}
                    onClick={handleSwap}
                    disabled={isTransactionLoading}
                >
                    {isTransactionLoading ? <><BiLoaderAlt className='animate-spin mr-2' /> Swapping...</> :
                         <>
                           <FaExchangeAlt className='mr-2'/> Swap
                         </>
                    }
                </button>
            </div>
        </div>
    );
}