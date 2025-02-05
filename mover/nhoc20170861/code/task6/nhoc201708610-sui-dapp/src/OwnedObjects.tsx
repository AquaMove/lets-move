import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";
import { Flex, Heading, Text } from "@radix-ui/themes";

/**
 * OwnedObjects component fetches and displays the objects owned by the connected wallet.
 */
export function OwnedObjects() {
  // Get the current account using the custom hook
  const account = useCurrentAccount();

  // Query to fetch owned objects using the Sui client
  const { data, isPending, error } = useSuiClientQuery(
    "getOwnedObjects",
    {
      owner: account?.address as string, // Use the account address as the owner
    },
    {
      enabled: !!account, // Enable the query only if the account is available
    },
  );

  // If no account is connected, return nothing
  if (!account) {
    return;
  }

  // Display error message if there's an error in fetching data
  if (error) {
    return <Flex>Error: {error.message}</Flex>;
  }

  // Display loading message while data is being fetched
  if (isPending || !data) {
    return <Flex>Loading...</Flex>;
  }

  // Render the list of owned objects or a message if no objects are owned
  return (
    <Flex direction="column" my="2">
      {data.data.length === 0 ? (
        <Text>No objects owned by the connected wallet</Text>
      ) : (
        <Heading size="4">Objects owned by the connected wallet</Heading>
      )}
      {data.data.map((object) => (
        <Flex key={object.data?.objectId}>
          <Text>Object ID: {object.data?.objectId}</Text>
        </Flex>
      ))}
    </Flex>
  );
}
