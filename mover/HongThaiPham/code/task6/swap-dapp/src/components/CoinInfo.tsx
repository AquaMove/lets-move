import { Avatar, Container, Flex, Heading } from "@radix-ui/themes";
import React from "react";
import { SWAP_COINS } from "../utils/constants";
import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";
import { amountForDisplay } from "../utils/network";
type Props = {
  name: string;
};
const CoinInfo: React.FC<Props> = ({ name }) => {
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
    <Flex direction="row" justify={"between"}>
      <Container>
        <Heading size="4">
          {data.iconUrl ? (
            <Avatar
              src={data.iconUrl}
              fallback={data.symbol}
              radius="full"
              mr={"3"}
            />
          ) : null}
          {data.name} - {data.symbol}
        </Heading>
        <Heading size="1">{data.description}</Heading>
      </Container>
      <Heading size="4">
        Balance:{" "}
        {balance
          ? Number(
              amountForDisplay(balance?.totalBalance, data.decimals),
            ).toLocaleString()
          : "0"}
      </Heading>
    </Flex>
  );
};

export default CoinInfo;
