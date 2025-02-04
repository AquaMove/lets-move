import { ConnectButton, useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";

import { Transfer } from "./Transfer"

function App() {

  const account = useCurrentAccount();
  function OwnedObjects() {
    const account = useCurrentAccount();
    const { data } = useSuiClientQuery('getOwnedObjects',
      { owner: account.address });

    if (!data) {
      return null;
    }

    return (<ul>
      {data.data.map((object) =>
        <li key={object.data?.objectId}> {object.data?.objectId}</li>)}
    </ul>);
  }

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      height: '100vh',
    }}>
      <ConnectButton />
      {!account && <div>No account connected</div>}
      {account && (
        <div>

          <h2>Current Account: </h2>
          <div>Address: {account.address}</div>
          <OwnedObjects />
          <Transfer />
        </div>
      )}
    </div>
  );
}

export default App;
