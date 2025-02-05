import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading } from "@radix-ui/themes";
import { WalletStatus } from "./WalletStatus";
import MintCoin from "./components/MintCoin";

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
          <Heading>
            <div className="text-2xl w-fit mb-7 mx-auto font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-blue-300 via-brown-500 to-purple-500">
              Mint coin Application
            </div>
          </Heading>
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
          <MintCoin />
          {/* <WalletStatus /> */}
        </Container>
      </Container>
    </>
  );
}

export default App;
