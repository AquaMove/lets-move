import CoinBlock from "./CoinBlock";

const MintCoin = () => {
  return (
    <div className="max-w-xl w-full mx-auto p-6">
      <div className="flex flex-col gap-4 relative mb-4">
        <CoinBlock name="FAUCET_COIN" />
      </div>
    </div>
  );
};

export default MintCoin;
