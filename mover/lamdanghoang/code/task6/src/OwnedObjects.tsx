import { useSuiClientQuery } from "@mysten/dapp-kit";

import { useCurrentAccount } from "@mysten/dapp-kit";

export function OwnedObjects() {
  const account = useCurrentAccount()!;
  const { data } = useSuiClientQuery("getOwnedObjects", {
    owner: account.address,
  });

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
