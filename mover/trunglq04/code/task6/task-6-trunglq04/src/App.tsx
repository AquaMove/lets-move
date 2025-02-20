import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
import { OwnedObjects } from "./OwnedObjects";
import { SendSui } from "./transfer";

function App() {
  const account = useCurrentAccount();
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
