import {ConnectButton, useCurrentAccount, useSuiClientQuery} from "@mysten/dapp-kit";
import { SendSui } from "./transfer";

function App() {
  // return (
  //   <>
  //     <Flex
  //       position="sticky"
  //       px="4"
  //       py="2"
  //       justify="between"
  //       style={{
  //         borderBottom: "1px solid var(--gray-a2)",
  //       }}
  //     >
  //       <Box>
  //         <Heading>dApp Starter Template</Heading>
  //       </Box>

  //       <Box>
  //         <ConnectButton />
  //       </Box>
  //     </Flex>
  //     <Container>
  //       <Container
  //         mt="5"
  //         pt="2"
  //         px="4"
  //         style={{ background: "var(--gray-a2)", minHeight: 500 }}
  //       >
  //         <WalletStatus />
  //       </Container>
  //     </Container>
  //   </>
  // );

  const account = useCurrentAccount();

  function OwnedObjects() {
    const account = useCurrentAccount()!;
    const {data} = useSuiClientQuery('getOwnedObjects', {owner: account.address});

    if (!data) {
      return null;
    }

    return (
      <ul>
        {data.data.map((object) => (
          <li key={object.data?.objectId}> {object.data?.objectId}</li>
        ))}
      </ul>
    );
  }

  return (
    <div>
      <ConnectButton />

      {!account && <div>No account connected</div>}

      {account && (
        <div>
          <section>Hello, world</section>
          <h2>Current account:</h2>
          <div>Address: {account.address}</div>
          <OwnedObjects />
          <SendSui />
        </div>
      )}
    </div>
  );
}

export default App;
