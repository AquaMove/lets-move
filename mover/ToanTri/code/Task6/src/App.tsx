import {
  ConnectButton,
  useCurrentAccount,
  useSuiClientQuery,
} from "@mysten/dapp-kit";
import { SendSui } from "./transfer";

function App() {
  const account = useCurrentAccount();

  function OwnedObjects() {
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

  return (
    <div>
      <ConnectButton />

      {!account && <div>No account connected</div>}

      {account && (
        <div>
          <section>XIN CHÀO SUIHUB. MÌNH LÀ ToanTri</section>
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
