'use client';
import React, { useState } from 'react';
import PoolToken from '@/components/PoolToken';
import SwapToken from '@/components/SwapToken';
import ConnectWalletButton from '@/components/ConnectButton';
import FaucetToken from '@/components/FaucetToken';

export default function Home() {
  const [activeTab, setActiveTab] = useState('Pool');

  return (
    <div className="relative bg-gray-100 min-h-screen">
      <div className="flex flex-col items-center">
        <h1 className="text-center font-extrabold text-5xl bg-gradient-to-r from-purple-500 to-blue-500 bg-clip-text text-transparent pt-12">
            SUI TESTNET
        </h1>
        <p className="mt-4 text-lg text-gray-700">Experience seamless token swaps on the SUI Testnet.</p>
      </div>

      <div className="flex justify-center space-x-4 mb-6 z-50 pt-12">
        <button
          className={`px-4 py-1 font-semibold rounded-lg transition-colors duration-200
                        ${
                            activeTab === 'Pool'
                                ? 'bg-blue-600 text-white shadow-md'
                                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                        }`}
          onClick={() => setActiveTab('Pool')}
        >
          Pool Token
        </button>
        <button
          className={`px-4 py-1 font-semibold rounded-lg transition-colors duration-200
                        ${
                            activeTab === 'Swap'
                                ? 'bg-blue-600 text-white shadow-md'
                                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                        }`}
          onClick={() => setActiveTab('Swap')}
        >
          Swap Token
        </button>
        <button
          className={`px-4 py-1 font-semibold rounded-lg transition-colors duration-200
                        ${
                            activeTab === 'faucetToken'
                                ? 'bg-blue-600 text-white shadow-md'
                                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                        }`}
          onClick={() => setActiveTab('faucetToken')}
        >
          FAUCET 
        </button>
        <ConnectWalletButton />
      </div>
      {activeTab === 'Pool' && <PoolToken />}
      {activeTab === 'Swap' && <SwapToken />}
      {activeTab === 'faucetToken' && <FaucetToken />}

    </div>
  );
}