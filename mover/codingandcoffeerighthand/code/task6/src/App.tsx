import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
import { Objs } from "./Objs";
import { SendSui } from "./SendSui";

function App() {
  const account = useCurrentAccount();
  return (
    <>
      <ConnectButton />
      {!account && <div>No acount connected</div>}
      {account && (
        <div>
          <h1>Connected account: {account.address}</h1>
          <Objs addr={account.address} />
        </div>
      )}
      <SendSui />
    </>
  );
}

export default App;
