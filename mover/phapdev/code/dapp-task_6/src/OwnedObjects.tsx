import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";

export function OwnedObjects() {
  const account = useCurrentAccount()!;
  const { data } = useSuiClientQuery("getOwnedObjects", {
    owner: account?.address
  });

  if (!data) { return null; };

  return (
		<ul className="flex flex-col gap-2">
			{data.data.map((object, index) => (
				<li className="bg-black/30 p-2 rounded-md" key={index}> {index} - {object.data?.objectId}</li>
			))}
		</ul>
	);
}
