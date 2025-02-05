import { ConnectButton, useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading } from "@radix-ui/themes";
import { WalletStatus } from "./WalletStatus";
import { Transaction } from "@mysten/sui/transactions";

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
          <SendSui />
        </Container>
      </Container>
    </>
  );
}

const SendSui = () => {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [10]);
    txb.transferObjects(
      [coin],
      "0xa26a4168569e815f4c382201d1b383f2722e7a5a3610aa4edc69d414e53dcd98",
    );

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (_result) => {
      alert("Sui sent successfully");
    });
  }

  return <button onClick={() => sendMessage()}>Send me Sui!</button>;
};

export default App;
