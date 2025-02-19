import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";
import { SWAP_COINS } from "../constants";
import { Avatar } from "@radix-ui/themes";

interface IProps {
  name: string;
}
const CoinInfo = ({ name }: IProps) => {
  const account = useCurrentAccount();
  const coin = SWAP_COINS[name];
  const { data } = useSuiClientQuery("getCoinMetadata", {
    coinType: coin.type,
  });

  const { data: balance } = useSuiClientQuery(
    "getBalance",
    {
      owner: account?.address as string,
      coinType: coin.type,
    },
    {
      enabled: !!account,
    },
  );
  if (!data) return null;

  return (
    <div className="flex items-center hover:shadow-xl px-4 pt-5 pb-8 gap-4 border rounded-2xl shadow-lg bg-white">
      {data.iconUrl ? (
        <Avatar src={data.iconUrl} fallback={data.symbol} radius="full" />
      ) : null}

      <div className="flex-1">
        <div className="text-lg text-black font-medium">{data.name}</div>
        <div className="text-sm text-gray-500">{data.symbol}</div>
      </div>

      <div>
        <div className="text-lg text-black font-medium">Balance</div>
        <div className="text-sm text-gray-500">
          {balance ? balance?.totalBalance?.toString() : "0"}
        </div>
      </div>
    </div>
  );
};

export default CoinInfo;
