import { useSignAndExecuteTransaction } from "@mysten/dapp-kit";
import { Transaction } from "@mysten/sui/transactions";
import { useState } from "react";
import {
  Container,
  Flex,
  Heading,
  Text,
  Button,
  Card,
  Box,
} from "@radix-ui/themes";
import {
  ConnectButton,
  useCurrentAccount,
  useSuiClientQuery,
} from "@mysten/dapp-kit";

export function SendSui() {
  const { mutateAsync: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransaction();
  const [digest, setDigest] = useState("");

  function sendMessage() {
    const txb = new Transaction();

    const coin = txb.splitCoins(txb.gas, [100]);
    txb.transferObjects(
      [coin],
      "0x7a84b64fb8b9aa90e99d7bb40db1de3ab88b9d9cd07f3e328dc50d4e7c860b95",
    );

    signAndExecuteTransactionBlock({
      transaction: txb,
    }).then(async (result) => {
      alert("Sui sent successfully");
      setDigest(result.digest);
    });
  }

  return (
    <Card>
      <Flex direction="column" gap="2">
        <Button onClick={() => sendMessage()}>Send me Sui!</Button>
        {digest && <Text>Transaction Digest: {digest}</Text>}
      </Flex>
    </Card>
  );
}

export function OwnedObjects() {
  const account = useCurrentAccount();
  const { data, isPending, error } = useSuiClientQuery(
    "getOwnedObjects",
    {
      owner: account?.address as string,
    },
    {
      enabled: !!account,
    },
  );

  if (!account) {
    return null;
  }

  if (error) {
    return <Text color="red">Error: {error.message}</Text>;
  }

  if (isPending || !data) {
    return <Text>Loading...</Text>;
  }

  return (
    <Card>
      <Flex direction="column" gap="2">
        {data.data.length === 0 ? (
          <Text>No objects owned by the connected wallet</Text>
        ) : (
          <Heading size="4">Objects owned by the connected wallet</Heading>
        )}
        {data.data.map((object) => (
          <Box key={object.data?.objectId}>
            <Text>Object ID: {object.data?.objectId}</Text>
          </Box>
        ))}
      </Flex>
    </Card>
  );
}

export function WalletStatus() {
  const account = useCurrentAccount();

  return (
    <Container my="2">
      <Heading mb="2">Wallet Status</Heading>
      {account ? (
        <Flex direction="column" gap="2">
          <Text>Wallet connected</Text>
          <Text>Address: {account.address}</Text>
        </Flex>
      ) : (
        <Text>Wallet not connected</Text>
      )}
    </Container>
  );
}

function App() {
  return (
    <Container>
      <Flex direction="column" gap="4" p="4">
        <ConnectButton />
        <WalletStatus />
        <OwnedObjects />
        <SendSui />
      </Flex>
    </Container>
  );
}

export default App;
