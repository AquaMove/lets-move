import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
import { OwnedObjects } from "./OwnedObjects.tsx";
import { SendSui } from "./transfer.tsx";
function App() {
  const account = useCurrentAccount();

  return (
    <div className="background-white p-4">
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
