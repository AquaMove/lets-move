/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
'use client';

import {
    useCurrentAccount,
    useSignAndExecuteTransaction,
    useSuiClientQuery,
} from '@mysten/dapp-kit';
import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import React, { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import { FaCoins, FaGasPump, FaPlus, FaMinus } from 'react-icons/fa';
import { BiLoaderAlt } from 'react-icons/bi';
import { motion } from 'framer-motion'
import { useCoinBalances, usePoolData } from '@/hook/useSwapToken';

const packageObjectId = process.env.NEXT_PUBLIC_SUI_PACKAGE_ID ?? '';
const faucetCoinType = process.env.NEXT_PUBLIC_FAUCET_COIN_TYPE ?? '';
const myCoinType = process.env.NEXT_PUBLIC_MY_COIN_TYPE ?? '';
const poolObjectId = process.env.NEXT_PUBLIC_POOL_OBJECT_ID ?? '';


interface PoolFields {
    balance_coin_a: any;
    balance_coin_b: any;
    total_lp_token_minted: any;
}

interface PoolInfo {
    balance_coin_a: number;
    balance_coin_b: number;
    total_lp_token_minted: number;
}

interface LPTokenBalance {
    balance: number;
}

interface SwapPoolLpToken {
    id: {
        id: string;
    };
    amount: number;
}
interface LpTokenObject {
    id: string;
    amount: number;
}
interface LpSelectModalProps {
    isOpen: boolean;
    onClose: () => void;
    lpObjectId: LpTokenObject[];
    onSelect: (objectId: string) => void;
    selectedLpObjectId: string;
}

const LpSelectModal: React.FC<LpSelectModalProps> = ({ isOpen, onClose, lpObjectId, onSelect, selectedLpObjectId }) => {
    if (!isOpen) return null;

    return (
         <div className="fixed inset-0 z-50 bg-black bg-opacity-50 flex items-center justify-center">
            <div className="bg-white rounded-lg p-6 max-w-md w-full relative">
                <div className='flex justify-between items-center mb-4'>
                    <h2 className="text-2xl font-semibold text-gray-800">Select LP Token</h2>
                      <button
                          onClick={onClose}
                        className="text-gray-600 hover:text-gray-800 focus:outline-none"
                      >
                          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                               <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                          </svg>
                      </button>
                </div>
                <div className="max-h-72 overflow-y-auto custom-scrollbar">
                    {lpObjectId && lpObjectId.length > 0 ? (
                        lpObjectId.map(item => (
                            <div
                                key={item.id}
                                className={`flex items-center justify-between border-b border-gray-200  p-3 cursor-pointer rounded-md transition-colors duration-200
                                      hover:bg-gray-100 mb-2
                                      ${selectedLpObjectId === item.id ? 'bg-blue-100  text-blue-700 font-semibold' : 'bg-gray-50 text-gray-700'}`}
                                onClick={() => onSelect(item.id)}
                            >
                                <div className="text-sm gap-y-2 flex flex-col">
                                        <span className="font-medium">ID: {item.id.substring(0, 6)}...{item.id.substring(item.id.length - 4)}</span>
                                        <span className="font-medium">Amount: {item.amount / 1000000000} LP</span>
                                </div>
                                {selectedLpObjectId === item.id && (
                                    <div className="absolute inset-0 border-blue-500 border-2 rounded-md pointer-events-none" />
                                )}
                            </div>
                        ))
                    ) : (
                        <p className="text-gray-500 text-sm mt-1">No LP tokens available</p>
                    )}
                </div>
                <div className='flex justify-end'>
                   <button
                         onClick={onClose}
                        className="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold py-2 px-4 rounded-md mt-4 focus:outline-none"
                     >
                       Cancel
                   </button>
                </div>

            </div>
        </div>
    );
};


export default function PoolToken() {
    const account = useCurrentAccount();
    const [suiClient, setSuiClient] = useState<SuiClient | null>(null);
    const [faucetAmount, setFaucetAmount] = useState('');
    const [myCoinAmount, setMyCoinAmount] = useState('');
    const [lpAmount, setLpAmount] = useState('');
    const [isTransactionLoading, setIsTransactionLoading] = useState(false);
    const { mutate: signAndExecuteTransaction } = useSignAndExecuteTransaction();
    const [gasEstimate, setGasEstimate] = useState<number | null>(null);
    const [lpBalance, setLpBalance] = useState<number | null>(null);
    const [faucetError, setFaucetError] = useState<string | null>(null);
    const [myCoinError, setMyCoinError] = useState<string | null>(null);
    const [lpError, setLpError] = useState<string | null>(null)
    const [activeTab, setActiveTab] = useState<'add' | 'remove'>('add')
    const [lpObjectId, setLpObjectId] = useState<LpTokenObject[]>([]);
    const [selectedLpObjectId, setSelectedLpObjectId] = useState<string>('');
    const [estimateBurnAmountsCoinA, setEstimateBurnAmountsA] = useState<number | string>();
    const [estimateBurnAmountsCoinB, setEstimateBurnAmountsB] = useState<number | string>();
    const [isModalOpen, setIsModalOpen] = useState(false);
    const targetLpType = `${packageObjectId}::move_swap::SwapPoolLpToken<${faucetCoinType}, ${myCoinType}>`;
    const [poolRefreshKey, setPoolRefreshKey] = useState(0);
    const { poolInfo, isPoolLoading, refetch: refetchPoolData } = usePoolData(poolObjectId, suiClient, poolRefreshKey);
    const [balancesRefreshKey, setBalancesRefreshKey] = useState(0);
    const { faucetCoinBalance, myCoinBalance, isBalancesLoading, refetch: refetchBalances } = useCoinBalances(account?.address, suiClient, faucetCoinType, myCoinType, balancesRefreshKey);
   
    
    const { data: lpData, isLoading: isLpDataLoading } = useSuiClientQuery('getOwnedObjects', {
        owner: account?.address as string,
        options: {
            showContent: true,
            showType: true,
        }
    }, {
        enabled: !!account?.address
    });


    useEffect(() => {
        if (lpData && lpData.data) {
            let totalLpBalance = 0;
            let tempLpObjects : LpTokenObject[] = [];
            for (const item of lpData.data) {
                if (item.data?.type === targetLpType) {
                    if (item.data.content && item.data.content.dataType === 'moveObject' && item.data.content.fields) {
                        const { amount, id } = item.data.content.fields as unknown as SwapPoolLpToken;
                        totalLpBalance += Number(amount);
                        const normalizedId = typeof id === 'string' ? id : id.id;
                         tempLpObjects = [
                           ...tempLpObjects,
                            { id: normalizedId, amount: Number(amount) }
                         ]
                    }
                }
            }
             setLpObjectId(tempLpObjects);
            setLpBalance(totalLpBalance / 1000000000);

        } else {
            setLpBalance(null);
        }
    }, [lpData, targetLpType]);
    useEffect(() => {
        const client = new SuiClient({ url: getFullnodeUrl('testnet') });
        setSuiClient(client);
    }, []);

    const handleLpObjectIdSelection = (objectId: string) => {
        setSelectedLpObjectId(objectId);
        const selectedItem = lpObjectId.find(item => item.id === objectId);
        if (selectedItem) {
            const amounts = estimateBurnAmounts(selectedItem.amount);
            setEstimateBurnAmountsA(amounts.amount_a_out);
            setEstimateBurnAmountsB(amounts.amount_b_out);
        }
        setIsModalOpen(false)
    }
    const handleFaucetAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setFaucetAmount(value);
        if (isNaN(Number(value)) || Number(value) <= 0) {
            setFaucetError('Please enter a valid positive number');
        } else {
            setFaucetError(null);
        }
    }

    const handleMyCoinAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setMyCoinAmount(value);
        if (isNaN(Number(value)) || Number(value) <= 0) {
            setMyCoinError('Please enter a valid positive number');
        } else {
            setMyCoinError(null);
        }
    }
    const handleLpAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setLpAmount(value);
        if (isNaN(Number(value)) || Number(value) <= 0) {
            setLpError('Please enter a valid positive number');
        } else {
            setLpError(null);
        }
    }

    const handleTabChange = (tab: 'add' | 'remove') => {
        setActiveTab(tab);
        setFaucetAmount('');
        setMyCoinAmount('');
        setLpAmount('')
        setSelectedLpObjectId('');
        setEstimateBurnAmountsA(undefined);
        setEstimateBurnAmountsB(undefined)
    }
     const handleOpenModal = () => {
        setIsModalOpen(true);
      };
    const handleCloseModal = () => {
        setIsModalOpen(false);
    }
    const handleAddLiquidity = async () => {
        if (!account?.address || !suiClient) {
            toast.error('Please connect your wallet first.');
            return;
        }

        if (!faucetAmount || isNaN(Number(faucetAmount)) || Number(faucetAmount) <= 0 ||
            !myCoinAmount || isNaN(Number(myCoinAmount)) || Number(myCoinAmount) <= 0
        ) {
            toast.error('Please enter valid amounts for both tokens.');
            return;
        }
        if (faucetError || myCoinError) {
            toast.error('Please fix input errors before submitting');
            return;
        }
        setIsTransactionLoading(true);

        try {
            const faucetAmountValue = Math.floor(Number(faucetAmount) * 1000000000);
            const myCoinAmountValue = Math.floor(Number(myCoinAmount) * 1000000000);

            const txb = new TransactionBlock();

            const faucetCoins = await suiClient.getCoins({
                owner: account.address,
                coinType: faucetCoinType
            });

            const myCoins = await suiClient.getCoins({
                owner: account.address,
                coinType: myCoinType
            });


            if (!faucetCoins || faucetCoins.data.length === 0 ||
                !myCoins || myCoins.data.length === 0
            ) {
                toast.error('No coins available for selected tokens');
                setIsTransactionLoading(false);
                return;
            }

            const faucetCoin = faucetCoins.data[0];
            const myCoin = myCoins.data[0];

            if (!faucetCoin || !myCoin) {
                toast.error('Coin object is undefined');
                setIsTransactionLoading(false);
                return;
            }

            const faucetCoinInput = txb.splitCoins(txb.object(faucetCoin.coinObjectId), [txb.pure(faucetAmountValue)]);
            const myCoinInput = txb.splitCoins(txb.object(myCoin.coinObjectId), [txb.pure(myCoinAmountValue)]);


            txb.moveCall({
                target: `${packageObjectId}::move_swap::create_lp_token`,
                arguments: [
                    txb.object(poolObjectId),
                    faucetCoinInput,
                    myCoinInput
                ],
            });


            const serializedTransaction = await txb.serialize();

            signAndExecuteTransaction(
                {
                    transaction: serializedTransaction,
                },
                {
                    onSuccess: (result) => {
                        toast.success('Liquidity added successfully!');
                         // Invalidate relevant queries
                            setBalancesRefreshKey(prev => prev + 1);
                            setPoolRefreshKey(prev => prev + 1);

                        console.log(result)
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
    function divideAndRoundUp(x: number, y: number): number {
        if (y === 0) {
            throw new Error("Division by zero is not allowed");
        }
        return Math.ceil(x / y);
    }
    const estimateBurnAmounts = (lpTokenAmount: number) => {
        if (poolInfo) {
            const amountA = (lpTokenAmount * poolInfo.balance_coin_a) / poolInfo.total_lp_token_minted;
            const amountB = (lpTokenAmount * poolInfo.balance_coin_b) / poolInfo.total_lp_token_minted;

            return {
                amount_a_out: amountA.toFixed(4),
                amount_b_out: amountB.toFixed(4)
            };
        }
        return { amount_a_out: '0.0000', amount_b_out: '0.0000' };
    };
    const handleRemoveLiquidity = async () => {
        if (!account?.address || !suiClient) {
            toast.error('Please connect your wallet first.');
            return;
        }

        // if (!lpAmount || isNaN(Number(lpAmount)) || Number(lpAmount) <= 0
        // ) {
        //     toast.error('Please enter valid LP token amounts.');
        //     return;
        // }
        if (lpError) {
            toast.error('Please fix input errors before submitting');
            return;
        }
        setIsTransactionLoading(true);

        try {
            // const lpAmountValue = Math.floor(Number(lpAmount) * 1000000000);
            if (!selectedLpObjectId) {
                toast.error('Selected LP token not found');
                setIsTransactionLoading(false);
                return;
            }
            const txb = new TransactionBlock();
            // const lpCoins = await suiClient.getOwnedObjects({
            //     owner: account.address,
            //     filter:{
            //         StructType: targetLpType,
            //     },
            //   }
            // );
            // console.log(lpCoins);
            // if (!lpCoins || lpCoins.data.length === 0) {
            //     toast.error('No LP tokens available');
            //     setIsTransactionLoading(false);
            //     return;
            // }

            // const lpCoin = lpCoins.data[0];


            // if (!lpCoin || !lpCoin.data?.objectId) {
            //     toast.error('LP coin object is undefined');
            //     setIsTransactionLoading(false);
            //     return;
            // }

            txb.moveCall({
                target: `${packageObjectId}::move_swap::burn_lp_token`,
                arguments: [
                    txb.object(poolObjectId),
                    txb.object(selectedLpObjectId),
                ],
            });

            const serializedTransaction = await txb.serialize();

            signAndExecuteTransaction(
                {
                    transaction: serializedTransaction,
                },
                {
                    onSuccess: (result) => {
                        toast.success('Liquidity removed successfully!');
                            // Invalidate relevant queries
                           setBalancesRefreshKey(prev => prev + 1);
                            setPoolRefreshKey(prev => prev + 1);
                          setSelectedLpObjectId('');
                          setEstimateBurnAmountsA(undefined);
                          setEstimateBurnAmountsB(undefined)
                        console.log(result)
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

    const handleAction = () => {
        if (activeTab === 'add') {
            handleAddLiquidity()
        } else {
            handleRemoveLiquidity()
        }
    }
    return (
        <div className="flex items-center justify-center p-4 relative overflow-hidden h-full bg-gray-100">
            <div className="w-full max-w-md bg-white rounded-xl shadow-lg p-6 border border-gray-200">
                <h2 className="text-2xl font-semibold mb-6 text-gray-800 text-center">
                    {activeTab === 'add' ? 'Add Liquidity' : 'Remove Liquidity'}
                </h2>
                {account?.address && (
                    <p className="text-center text-gray-500 mb-5">
                        Connected Account: <span className='font-semibold text-gray-700'>{account?.address.substring(0, 6)}...{account?.address.substring(account?.address.length - 4)}</span>
                    </p>
                )}

                <div className="flex justify-center space-x-4 mb-4">
                    <button
                        className={`px-4 py-2 font-semibold rounded-lg transition-colors duration-200 relative overflow-hidden
                    ${activeTab === 'add'
                                ? 'bg-blue-600 text-white shadow-md'
                                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                            }`}
                        onClick={() => handleTabChange('add')}
                    >
                        <motion.span
                            layout
                            transition={{ duration: 0.2 }}
                        >
                            Add
                        </motion.span>
                        {activeTab === 'add' && (
                            <motion.div
                                layoutId='underline'
                                className='absolute bottom-0 left-0 w-full h-[3px] bg-gradient-to-r from-purple-500 to-blue-500 rounded-full'
                                transition={{ duration: 0.3 }}
                            />
                        )}
                    </button>
                    <button
                        className={`px-4 py-2 font-semibold rounded-lg transition-colors duration-200 relative overflow-hidden
                    ${activeTab === 'remove'
                                ? 'bg-blue-600 text-white shadow-md'
                                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                            }`}
                        onClick={() => handleTabChange('remove')}
                    >
                        <motion.span
                            layout
                            transition={{ duration: 0.2 }}
                        >
                            Remove
                        </motion.span>
                        {activeTab === 'remove' && (
                            <motion.div
                                layoutId='underline'
                                className='absolute bottom-0 left-0 w-full h-[3px] bg-gradient-to-r from-purple-500 to-blue-500 rounded-full'
                                transition={{ duration: 0.3 }}
                            />
                        )}
                    </button>
                </div>


                {/* Pool info */}
                {isPoolLoading ? <div className="text-gray-500 text-sm mb-4 flex items-center justify-center">
                    <BiLoaderAlt className='animate-spin mr-2' /> Loading pool data...
                </div>
                    : poolInfo && (
                        <div className="text-gray-600 text-sm mb-4">
                            <div className="flex justify-between">
                                <span className='font-medium text-gray-700'>Pool Balance Faucet Coin:</span>
                                <span>{poolInfo.balance_coin_a}</span>
                            </div>
                            <div className="flex justify-between">
                                <span className='font-medium text-gray-700'>Pool Balance My Coin:</span>
                                <span>{poolInfo.balance_coin_b}</span>
                            </div>
                            <div className="flex justify-between">
                                <span className='font-medium text-gray-700'>Total LP Minted:</span>
                                <span>{poolInfo.total_lp_token_minted}</span>
                            </div>
                        </div>
                    )}

                {lpBalance !== null && (
                    <div className="text-gray-600 text-sm mb-4">
                        <div className="flex justify-between">
                            <span className='font-medium text-gray-700'>Your LP Token Balance:</span>
                            <span>{lpBalance}</span>
                        </div>
                    </div>
                )}

                {activeTab === 'add' && (
                    <>
                        <div className="mb-4">
                            <div className="flex justify-between items-center mb-2">
                                <label className="block text-sm font-medium text-gray-700">
                                    Faucet Coin Amount
                                </label>
                                <span className="text-gray-500 text-sm">Balance: {faucetCoinBalance}</span>
                            </div>
                            <div className='relative'>
                                <input
                                    className={`w-full bg-gray-50 border border-gray-300 text-gray-700 rounded-md p-2 focus:outline-none pr-10
                                    ${faucetError ? 'border-red-500' : ''}  placeholder:text-gray-400`}
                                    type="number"
                                    placeholder="0.0"
                                    value={faucetAmount}
                                    onChange={handleFaucetAmountChange}
                                />
                                <FaCoins className='absolute top-1/2 right-3 transform -translate-y-1/2 text-gray-500' />
                            </div>
                            {faucetError && <p className="text-red-500 text-sm mt-1">{faucetError}</p>}
                        </div>

                        <div className="mb-4">
                            <div className="flex justify-between items-center mb-2">
                                <label className="block text-sm font-medium text-gray-700">
                                    My Coin Amount
                                </label>
                                <span className="text-gray-500 text-sm">Balance: {myCoinBalance}</span>
                            </div>
                            <div className='relative'>
                                <input
                                    className={`w-full bg-gray-50 border border-gray-300 text-gray-700 rounded-md p-2 focus:outline-none pr-10
                                        ${myCoinError ? 'border-red-500' : ''}  placeholder:text-gray-400`}
                                    type="number"
                                    placeholder="0.0"
                                    value={myCoinAmount}
                                    onChange={handleMyCoinAmountChange}
                                />
                                <FaCoins className='absolute top-1/2 right-3 transform -translate-y-1/2 text-gray-500' />
                            </div>
                            {myCoinError && <p className="text-red-500 text-sm mt-1">{myCoinError}</p>}
                        </div>
                    </>
                )}
                {activeTab === 'remove' && (
                    <div className="mb-4">
                        <div className="flex justify-between items-center mb-2">
                            <label className="block text-sm font-medium text-gray-700">
                                {selectedLpObjectId ? "Selected LP Token" : "Select LP Token to Remove"}
                            </label>
                        </div>
                        <div className="relativ  rounded-md p-2">
                            {selectedLpObjectId ? (
                                lpObjectId.find(item => item.id === selectedLpObjectId) ? (
                                    <div
                                    className={`flex items-center justify-between p-3 cursor-pointer  transition-colors duration-200
                                        hover:bg-gray-100 mb-2
                                        `}
                                    onClick={handleOpenModal}
                                >
                                    <div className="text-sm gap-x-2 flex">
                                        <span className="font-medium">ID: {selectedLpObjectId.substring(0, 6)}...{selectedLpObjectId.substring(selectedLpObjectId.length - 4)}</span>
                                        <span className="font-medium">Amount:</span> {(lpObjectId.find(item => item.id === selectedLpObjectId)?.amount ?? 0) / 1000000000} LP
                                    </div>
                            </div>
                                ) : (
                                    <p className="text-gray-500 text-sm mt-1">No LP tokens available</p>
                                )

                            ) : (
                                 <div className='flex items-center  border-gray-300  rounded-md p-2 cursor-pointer'  onClick={handleOpenModal}>
                                       <span className="text-gray-500 text-sm">
                                             Click to select LP token
                                        </span>
                                  </div>
                            )}
                        </div>
                        {selectedLpObjectId && (
                            <div className="mt-4">
                                <div className="flex justify-between">
                                    <span className='font-medium text-gray-700'>Estimated Amount Faucet Coin:</span>
                                    <span>{estimateBurnAmountsCoinA}</span>
                                </div>
                                <div className="flex justify-between">
                                    <span className='font-medium text-gray-700'>Estimated Amount My Coin:</span>
                                    <span>{estimateBurnAmountsCoinB}</span>
                                </div>
                            </div>
                        )}
                        {lpError && <p className="text-red-500 text-sm mt-1">{lpError}</p>}
                    </div>
                )}


                <div className="text-gray-600 text-sm mb-4 flex items-center justify-between">
                    <span className='flex items-center font-medium text-gray-700'>
                        <FaGasPump className='mr-1' /> Gas Estimate:
                    </span>
                    <span>{gasEstimate ? gasEstimate.toFixed(4) : '0.0000'} SUI</span>
                </div>


                <button
                    className={`w-full  text-white font-semibold py-3 rounded-xl hover:opacity-90 transition flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed
                ${activeTab === 'add' ? 'bg-green-500 hover:bg-green-600' : 'bg-red-500 hover:bg-red-600'}`}
                    onClick={handleAction}
                    disabled={isTransactionLoading}
                >
                    {isTransactionLoading ? <><BiLoaderAlt className='animate-spin mr-2' /> {activeTab === 'add' ? 'Adding Liquidity...' : 'Removing Liquidity...'}</> : activeTab === 'add' ? <> <FaPlus className='mr-2' /> Add Liquidity</> : <><FaMinus className='mr-2' /> Remove Liquidity</>}
                </button>
            </div>
            <LpSelectModal
                isOpen={isModalOpen}
                onClose={handleCloseModal}
                lpObjectId={lpObjectId}
                onSelect={handleLpObjectIdSelection}
                selectedLpObjectId={selectedLpObjectId}
            />
        </div>
    );
}