import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
import { isValidSuiObjectId } from "@mysten/sui/utils";
import { Box, Button, Container, Flex, Heading } from "@radix-ui/themes";
import * as React from "react";
import { OwnedObjects } from "./OwnedObjects";
import { SendSui } from "./send_sui/send-sui";
import "./Global.styled.css";
import { TESTNET_COUNTER_PACKAGE_ID } from "./constants";
import { Counter } from "./Counter";
import { CreateCounter } from "./CreateCounter";

function App() {
  const [digest, setDigest] = React.useState<string | null>(null);
  const [state, setState] = React.useState({
    displayDigest: false,
    displayObject: false,
  });

  const [counterId, setCounter] = React.useState(() => {
    const hash = window.location.hash.slice(1);
    console.log("Hash:", hash);
    return isValidSuiObjectId(hash) ? hash : null;
  });

  const account = useCurrentAccount();
  const currentAccount = useCurrentAccount();
  const packageCounter = TESTNET_COUNTER_PACKAGE_ID;
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

        <div className="flex flex-row gap-5">
          <SendSui digest={digest} setDigest={setDigest} />
          <ConnectButton />
        </div>
      </Flex>
      <Container>
        <Container
          mt="5"
          pt="2"
          px="4"
          style={{ background: "var(--gray-a2)", minHeight: 500 }}
        >
          {digest && state.displayDigest && <div className="text-lg font-bold bg-black/30"><a href={`https://suiscan.xyz/testnet/tx/${digest}`} target="_blank">disget: {digest}</a></div>}
          <Button onClick={() => setState({ ...state, displayDigest: !state.displayDigest })}>
            {state.displayDigest ? "Hide Digest" : "Show Digest"}
          </Button>

          <Button onClick={() => setState({ ...state, displayObject: !state.displayObject })}>
            {state.displayObject ? "Hide Object" : "Show Object"}
          </Button>
          {state.displayObject && account && (
            <div className="flex flex-col gap-5">
              <div className="flex flex-col gap-2 bg-black/20 p-4 rounded-md">
                <section className="text-2xl font-bold">Hello, world</section>
                <h2 className="text-xl font-bold">Current account:</h2>
                <div className="text-lg font-bold bg-black/30">
                  Address: {account.address}
                </div>
              </div>
              <div className="flex flex-col gap-2 bg-black/20 p-4 rounded-md">
                <OwnedObjects />
              </div>
            </div>
          )}
          <div className="flex flex-col gap-2 bg-black/20 p-4 rounded-md">
            <section className="text-2xl font-bold">Contract</section>
            <h2 className="text-xl font-bold">Contract address:  {packageCounter ? <a className="text-blue-500" href={`https://suiscan.xyz/testnet/object/${packageCounter}`} target="_blank">{packageCounter}</a> : "None"}</h2>
            <div className="text-lg font-bold bg-black/30">
              Address: {account?.address}
            </div>
          </div>
          {/* Interaction with Counter smartcontract  */}
          {currentAccount ? (
              counterId ? (
                <Counter id={counterId} />
              ) : (
                <CreateCounter
                  onCreated={(id) => {
                    window.location.hash = id;
                    setCounter(id);
                  }}
                />
              )
            ) : (
              <Heading>Please connect your wallet</Heading>
            )}
        </Container>
      </Container>
    </>
  );
}

export default App;
