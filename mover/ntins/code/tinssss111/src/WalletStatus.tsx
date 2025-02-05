import { useCurrentAccount } from "@mysten/dapp-kit";
import { Container, Flex, Heading, Text, Card, Box } from "@radix-ui/themes";
import { OwnedObjects } from "./OwnedObjects";

export function WalletStatus() {
  const account = useCurrentAccount();

  return (
    <Container my="4">
      <Card variant="classic" style={{ maxWidth: 600, margin: "0 auto" }}>
        <Flex direction="column" gap="4" p="4">
          <Heading size="5" align="center" mb="2">
            Wallet Status
          </Heading>

          {account ? (
            <Flex direction="column" gap="2">
              <Text size="3" weight="bold" color="green">
                Wallet Connected
              </Text>
              <Box
                p="3"
                style={{
                  backgroundColor: "var(--gray-2)",
                  borderRadius: "var(--radius-2)",
                }}
              >
                <Text size="2" color="gray">
                  Address:
                </Text>
                <Text size="3" weight="bold">
                  {account.address}
                </Text>
              </Box>
            </Flex>
          ) : (
            <Text size="3" color="red" weight="bold">
              Wallet Not Connected
            </Text>
          )}

          <Box mt="4">
            <OwnedObjects />
          </Box>
        </Flex>
      </Card>
    </Container>
  );
}
