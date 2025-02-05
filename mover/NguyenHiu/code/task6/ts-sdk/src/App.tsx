import { ConnectButton, useCurrentAccount } from "@mysten/dapp-kit";
// import { OwnedObjects } from "./OwnedObjects";
import { SendSui } from './transfer';
import './App.css'; // Import the CSS file

function App() {
	const account = useCurrentAccount();

	return (
		<div className="background">
			<div className="shape circle shape1"></div>
			<div className="shape circle shape2"></div>
			<div className="shape square shape3"></div>
			<div className="shape triangle shape4"></div>

			<div className="connect-button">
				<ConnectButton />
			</div>

			<div className="text-box">
				{!account && <div className="center-content" style={{fontWeight: 'bold'}}>No account connected</div>}

				{account && (
					<>
						<div className="top-left">
							<section style={{ fontWeight: 'bold' }}>First dApp on SUI</section>
							<p>Github ID: <a target="_blank" href="http://github.com/NguyenHiu">NguyenHiu</a></p>
						</div>

						<div className="center-content">
							<SendSui />
						</div>

					</>

				)}
			</div>
		</div>
	);
}

export default App;