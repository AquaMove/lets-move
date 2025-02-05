import { useCurrentAccount } from "@mysten/dapp-kit";
import "./styles/WalletStatus.css";

export function WalletStatus() {
  const account = useCurrentAccount();

  return (
    <div className="wallet-status">
      <h2 className="wallet-status-title">Wallet Status</h2>
      {account ? (
        <div className="wallet-info pixel-borders">
          <p className="address">Address:</p>
          <p className="address-value">{account.address}</p>
        </div>
      ) : (
        <p className="wallet-not-connected pixel-borders">
          Wallet not connected
        </p>
      )}
    </div>
  );
}
