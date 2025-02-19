import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading, Theme } from "@radix-ui/themes";
import { WalletStatus } from "./WalletStatus";
import { SendSui } from "./transfer";

function App() {
  return (
    <Theme appearance="light" accentColor="blue" grayColor="sand" radius="large" scaling="95%">
      <Flex
        position="sticky"
        px="4"
        py="3"
        justify="between"
        align="center"
        style={{
          borderBottom: "1px solid var(--gray-a4)",
          background: "var(--gray-a2)",
          boxShadow: "0 2px 4px rgba(0,0,0,0.1)",
        }}
      >
        <Box>
          <Heading size="5" style={{ color: "var(--accent-9)", marginTop: "1rem", marginLeft: "1rem" }}>Sender Sui Token dApp</Heading>
        </Box>

        <Box>
          <ConnectButton />
        </Box>
      </Flex>
      <Container size="3">
        <Container
          mt="6"
          pt="4"
          px="6"
          style={{
            background: "var(--gray-a2)",
            minHeight: 500,
            borderRadius: "var(--radius-4)",
            boxShadow: "0 4px 6px rgba(0,0,0,0.1)",
          }}
        >
          <WalletStatus />
          <SendSui />
        </Container>
      </Container>
    </Theme>
  );
}

export default App;