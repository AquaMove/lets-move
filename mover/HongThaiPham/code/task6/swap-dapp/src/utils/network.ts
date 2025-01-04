export const getExplorerUrl = (digest: string) =>
  `https://suiscan.xyz/testnet/tx/${digest}`;

export const amountForDisplay = (
  amount: number | string | bigint,
  decimals: number,
) => BigInt(amount) / BigInt(10 ** decimals);
