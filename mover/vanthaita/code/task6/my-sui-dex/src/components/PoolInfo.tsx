import React from 'react';

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
            {isPoolLoading ? <div className="text-gray-400 text-sm mb-4">Loading Pool data...</div>
                : poolInfo && (
                    <div className="text-gray-400 text-sm mb-4">
                        <div className="flex justify-between">
                            <span>Pool Balance Faucet Coin:</span>
                            <span>{poolInfo.balance_coin_a}</span>
                        </div>
                        <div className="flex justify-between">
                            <span>Pool Balance My Coin:</span>
                            <span>{poolInfo.balance_coin_b}</span>
                        </div>
                        <div className="flex justify-between">
                            <span>Total LP Minted:</span>
                            <span>{poolInfo.total_lp_token_minted}</span>
                        </div>
                    </div>
                )}
        </>
    );
};

export default PoolInfo;