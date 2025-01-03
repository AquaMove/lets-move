/* eslint-disable @typescript-eslint/no-explicit-any */
import { useSuiClientQuery } from "@mysten/dapp-kit";
import { SuiClient } from "@mysten/sui.js/client"; //Import ở đây
import { useEffect, useState } from "react";

interface PoolFields {
    balance_coin_a: any;
    balance_coin_b: any;
    total_lp_token_minted: any;
}
export const usePoolData = (poolObjectId: string, suiClient: SuiClient | null) => {
    const [poolInfo, setPoolInfo] = useState<{
        balance_coin_a: number;
        balance_coin_b: number;
        total_lp_token_minted: number;
    } | null>(null);
    const [isPoolLoading, setIsPoolLoading] = useState(true);

    const { data: poolData, isLoading: isPoolDataLoading } = useSuiClientQuery('getObject', {
        id: poolObjectId,
        options: {
            showContent: true
        }
    }, {
        enabled: !!poolObjectId && !!suiClient
    });

    useEffect(() => {
        setIsPoolLoading(isPoolDataLoading)
    }, [isPoolDataLoading])


    useEffect(() => {
        if (poolData && poolData.data?.content) {
            if (poolData.data.content.dataType === 'moveObject' && poolData.data.content.fields) {
                const { balance_coin_a, balance_coin_b, total_lp_token_minted } = poolData.data.content.fields as unknown as PoolFields;
                setPoolInfo({
                    balance_coin_a: Number(balance_coin_a || 0) / 1000000000,
                    balance_coin_b: Number(balance_coin_b || 0) / 1000000000,
                    total_lp_token_minted: Number(total_lp_token_minted || 0),
                });
            }
        }
    }, [poolData]);
  
    return { poolInfo, isPoolLoading };
}

export const useCoinBalances = (address: string | undefined, suiClient: SuiClient | null, faucetCoinType: string, myCoinType: string) => {
    const [faucetCoinBalance, setFaucetCoinBalance] = useState(0);
    const [myCoinBalance, setMyCoinBalance] = useState(0);
    const [isBalancesLoading, setIsBalancesLoading] = useState(true)

     const { data: myCoinData, isLoading: myCoinLoading } = useSuiClientQuery('getBalance', {
         owner: address as string,
         coinType: myCoinType,
     }, {
         enabled: !!address
     });
    const { data: faucetCoinData, isLoading: faucetCoinLoading } = useSuiClientQuery('getBalance', {
        owner: address as string,
        coinType: faucetCoinType,
    }, {
        enabled: !!address
    });
    
     useEffect(() => {
        setIsBalancesLoading(myCoinLoading || faucetCoinLoading)
    },[myCoinLoading, faucetCoinLoading])

    useEffect(() => {
        if (faucetCoinData) {
            setFaucetCoinBalance(Number(faucetCoinData.totalBalance) / 1000000000);
        }
    }, [faucetCoinData]);

    useEffect(() => {
        if (myCoinData) {
            setMyCoinBalance(Number(myCoinData.totalBalance) / 1000000000);
        }
    }, [myCoinData]);
    return { faucetCoinBalance, myCoinBalance, isBalancesLoading }
}