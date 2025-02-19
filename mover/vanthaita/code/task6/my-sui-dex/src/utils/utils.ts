/* eslint-disable @typescript-eslint/no-explicit-any */
interface PoolFields {
    balance_coin_a: any;
    balance_coin_b: any;
    total_lp_token_minted: any;
}
export const calculateToAmount = (amountIn: string, poolInfo: PoolFields | null, fromToken: string): string => {
      if (!poolInfo) return "Calculated";
      if (!amountIn || isNaN(Number(amountIn)) || Number(amountIn) <= 0) {
          return "Calculated";
      }
  
      const amount = Number(amountIn);
      const { balance_coin_a, balance_coin_b } = poolInfo;
  
      if (balance_coin_a <= 0 || balance_coin_b <= 0) {
          return "Insufficient pool balance";
      }
  
      let x, y;
      if (fromToken === 'FAUCET_COIN') {
          x = balance_coin_a;
          y = balance_coin_b;
      } else {
          x = balance_coin_b;
          y = balance_coin_a;
      }
  
  
      const k = x * y;
      const new_x = x + amount; 
      const amountOut = y - (k / new_x) 
  
  
      if (amountOut < 0) {
          return 'Insufficient pool balance';
      }
  
      return amountOut.toFixed(6);
};