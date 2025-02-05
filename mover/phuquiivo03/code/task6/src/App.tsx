import { ConnectButton ,useCurrentAccount } from "@mysten/dapp-kit";
import { SendSui } from "./send";
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
          <SendSui />
          {/* <OwnedObjects />  */}
				</div>
 
			)}
		</div>
  );
}

export default App;
