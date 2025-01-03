import React, { useState, useEffect } from 'react';
import { FaCoins, FaExchangeAlt } from 'react-icons/fa';

interface SwapFormProps {
    fromToken: string;
    toToken: string;
    fromAmount: string;
    toAmount: string;
    faucetCoinBalance: number;
    myCoinBalance: number;
    onFromTokenChange: (e: React.ChangeEvent<HTMLSelectElement>) => void;
    onToTokenChange: (e: React.ChangeEvent<HTMLSelectElement>) => void;
    onFromAmountChange: (value: string) => void;
    isBalancesLoading: boolean;
}

const SwapForm: React.FC<SwapFormProps> = ({
    fromToken,
    toToken,
    fromAmount,
    toAmount,
    faucetCoinBalance,
    myCoinBalance,
    onFromTokenChange,
    onToTokenChange,
    onFromAmountChange,
    isBalancesLoading,
}) => {
    const [isFromAmountFocused, setIsFromAmountFocused] = useState(false);
    const [localFromAmount, setLocalFromAmount] = useState(fromAmount);

    useEffect(() => {
        setLocalFromAmount(fromAmount);
    }, [fromAmount]);


    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setLocalFromAmount(value)
        if (!isNaN(Number(value))) {
            onFromAmountChange(value)
         }
    };
     const handleFocus = () => {
        setIsFromAmountFocused(true);
     };
     const handleBlur = () => {
        setIsFromAmountFocused(false);
     };

    return (
        <>
            <div className="mb-6">
                <div className={`bg-white rounded-lg p-4 relative border border-gray-200 ${isFromAmountFocused ? 'ring-2 ring-blue-500' : ''}`}>
                    <div className='flex justify-between items-center mb-3'>
                        <label className="block text-sm font-medium text-gray-700">
                            From
                        </label>
                        <div className="text-gray-500 text-sm">Balance: {isBalancesLoading ? "Loading" : fromToken === 'FAUCET_COIN' ? faucetCoinBalance : myCoinBalance}</div>
                    </div>
                    <div className="flex items-center">
                        <div className='flex gap-x-2 items-center justify-center'>
                            <FaCoins className=' text-gray-500' />
                            <select
                                className="flex-1 bg-transparent border-none text-gray-700 focus:outline-none pr-2 appearance-none text-sm"
                                value={fromToken}
                                onChange={onFromTokenChange}
                            >
                                <option value="FAUCET_COIN">FAUCET_COIN</option>
                                <option value="MY_COIN">MY_COIN</option>
                            </select>
                        </div>
                        <input
                            type="text"
                            className="flex-1 text-right bg-transparent border-none text-gray-700 focus:outline-none  placeholder:text-gray-400 placeholder:italic text-sm"
                            placeholder="0.0"
                            value={localFromAmount}
                            onChange={handleInputChange}
                            onFocus={handleFocus}
                            onBlur={handleBlur}
                        />                        
                    </div>
                </div>

            </div>
            <div className='mb-6 flex justify-center items-center'>
                <div className='bg-blue-500 rounded-full p-2'>
                    <FaExchangeAlt className='text-gray-100' />
                </div>
            </div>
            {/* To Token */}
            <div className="mb-6">
                <div className="bg-white rounded-lg p-4 border border-gray-200">
                    <div className='flex justify-between items-center mb-3'>
                        <label className="block text-sm font-medium text-gray-700">
                            To
                        </label>
                        <div className="text-gray-500 text-sm">Balance: {isBalancesLoading ? "Loading" : toToken === 'FAUCET_COIN' ? faucetCoinBalance : myCoinBalance}</div>
                    </div>
                    <div className="flex items-center">
                            <div className='flex gap-x-2 items-center justify-center'>
                                <FaCoins className=' text-gray-500' />
                                <select
                                    className="flex-1 bg-transparent border-none text-gray-700 focus:outline-none pr-2 appearance-none text-sm"
                                    value={toToken}
                                    onChange={onToTokenChange}
                                >
                                    <option value="MY_COIN">MY_COIN</option>
                                    <option value="FAUCET_COIN">FAUCET_COIN</option>
                                </select>
                            </div>
                        <input
                            className="flex-1 text-right bg-transparent border-none text-gray-700 focus:outline-none  placeholder:text-gray-400 placeholder:italic text-sm"
                            type="text"
                            placeholder="Calculated"
                            value={toAmount}
                            disabled
                        />
                    </div>
                </div>
            </div>
        </>
    );
};

export default SwapForm;