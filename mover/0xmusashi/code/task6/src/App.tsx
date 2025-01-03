import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading } from "@radix-ui/themes";
import { WalletStatus } from "./WalletStatus";
import { useSignAndExecuteTransaction, useCurrentAccount } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';

function App() {
  return (
    <>
      <Flex
        position="sticky"
        px="4"
        py="2"
        justify="between"
        style={{
          borderBottom: "1px solid var(--gray-a2)",
        }}
      >
        <Box>
          <Heading>dApp Starter Template</Heading>
        </Box>

        <Box>
          <ConnectButton />
        </Box>
      </Flex>
      <Container>
        <Container
          mt="5"
          pt="2"
          px="4"
          style={{ background: "var(--gray-a2)", minHeight: 500 }}
        >
          <WalletStatus />
        </Container>
        <Container
          mt="5"
          pt="2"
          px="4"
          style={{ background: "var(--gray-a2)", minHeight: 500 }}
        >
          <SendSui />
        </Container>
      </Container>
    </>
  );
}

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } = useSignAndExecuteTransaction();

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [10]);
    txb.transferObjects([coin], '0x82fdfa1815b81644947efdb1b6e8e7c88d2e627c11dcb6efd97fa5bc7984ba26');

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (_result) => {
      alert('Sui sent successfully');
    });
  }

  return <button onClick={() => sendMessage()}>Send me Sui!</button>;
}

export default App;
