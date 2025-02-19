import React from 'react';
import { BiLoaderAlt } from 'react-icons/bi';

interface PoolInfoProps {
    isPoolLoading: boolean;
    poolInfo: {
        balance_coin_a: number;
        balance_coin_b: number;
        total_lp_token_minted: number;
    } | null;
}


const PoolInfo: React.FC<PoolInfoProps> = ({ isPoolLoading, poolInfo }) => {
    return (
        <>
            {isPoolLoading ? (
                 <div className="text-gray-500 text-sm mb-4 flex items-center justify-center">
                    <BiLoaderAlt className='animate-spin mr-2' /> Loading pool data...
                </div>
            ) : poolInfo ? (
                <div className="text-gray-600 text-sm mb-4">
                    <div className="flex justify-between py-1">
                       <span className='font-medium text-gray-700'>Pool Balance Faucet Coin:</span>
                        <span>{poolInfo.balance_coin_a}</span>
                    </div>
                    <div className="flex justify-between py-1">
                        <span className='font-medium text-gray-700'>Pool Balance My Coin:</span>
                        <span>{poolInfo.balance_coin_b}</span>
                    </div>
                    <div className="flex justify-between py-1">
                        <span className='font-medium text-gray-700'>Total LP Minted:</span>
                        <span>{poolInfo.total_lp_token_minted}</span>
                    </div>
                </div>
            ) : null}
        </>
    );
};

export default PoolInfo;