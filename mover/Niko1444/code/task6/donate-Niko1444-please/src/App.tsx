import { ConnectButton } from "@mysten/dapp-kit";
import { SendSui } from "./transfer";
import { WalletStatus } from "./WalletStatus";
import "./styles/App.css";
import "./styles/global.css";

function App() {
  return (
    <div className="app">
      <nav className="navbar pixel-borders">
        <h1 className="app-title">Donate to Niko1444!</h1>
        <ConnectButton />
      </nav>

      <main className="main-content">
        <div className="game-boy pixel-borders">
          <div className="screen pixel-borders">
            <WalletStatus />
            <SendSui />
          </div>
          <div className="controls">
            <div className="d-pad">
              <div className="d-pad-button up"></div>
              <div className="d-pad-button right"></div>
              <div className="d-pad-button down"></div>
              <div className="d-pad-button left"></div>
            </div>
            <div className="action-buttons">
              <div className="action-button"></div>
              <div className="action-button"></div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;
