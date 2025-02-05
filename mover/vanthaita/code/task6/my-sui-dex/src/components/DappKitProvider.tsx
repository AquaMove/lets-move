'use client'
import { createNetworkConfig, SuiClientProvider, WalletProvider } from '@mysten/dapp-kit';
import { getFullnodeUrl } from '@mysten/sui/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import '@mysten/dapp-kit/dist/index.css';
import { ToastContainer } from 'react-toastify';
export default function DappKitProvider({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const { networkConfig } = createNetworkConfig({
    testnet: { url: getFullnodeUrl('testnet') },
    mainnet: { url: getFullnodeUrl('mainnet') },
  });
  const queryClient = new QueryClient();
  return (
    <QueryClientProvider client={queryClient}>
        <SuiClientProvider networks={networkConfig} defaultNetwork="testnet">
        <WalletProvider autoConnect> 
            {children}
            <ToastContainer />
        </WalletProvider>
        </SuiClientProvider>
    </QueryClientProvider>
  );
}
