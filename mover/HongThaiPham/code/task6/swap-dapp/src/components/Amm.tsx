import {
  Box,
  Card,
  Flex,
  Heading,
  IconButton,
  Text,
  TextField,
} from "@radix-ui/themes";
import { useState } from "react";
import { UpdateIcon } from "@radix-ui/react-icons";
import MintFauCetCoinButton from "./MintFauCetCoinButton";
import CoinInfo from "./CoinInfo";
import SwapButton from "./SwapButton";
const Amm = () => {
  const [fromCoin, setFromCoin] = useState("FAUCET_COIN");
  const [toCoin, setToCoin] = useState("MY_COIN");
  const [fromAmount, setFromAmount] = useState(0);
  const [toAmount, setToAmount] = useState(0);

  const handleChangeCoin = () => {
    const temp = fromCoin;
    setFromCoin(toCoin);
    setToCoin(temp);
  };

  return (
    <Flex direction="column" gap={"5"}>
      <Heading size="6" align={"center"}>
        Swap{" "}
        <Text as="span" color="purple">
          {fromCoin}
        </Text>{" "}
        to{" "}
        <Text as="span" color="orange">
          {toCoin}
        </Text>
      </Heading>
      <Flex justify={"center"}>
        <MintFauCetCoinButton />
      </Flex>
      <Flex justify={"center"}>
        <Box width={"100%"}>
          <Card>
            <Flex
              justify="center"
              align={"center"}
              direction={"column"}
              gapY={"5"}
            >
              <Flex
                direction={"column"}
                width={"100%"}
                style={{
                  background: "purple",
                  padding: "10px",
                  borderRadius: "5px",
                }}
                gap={"5"}
              >
                <CoinInfo name={fromCoin} />
                <TextField.Root
                  size="3"
                  placeholder="Input amount"
                  value={fromAmount}
                  onChange={(e) => setFromAmount(Number(e.target.value))}
                />
              </Flex>

              <IconButton onClick={handleChangeCoin}>
                <UpdateIcon width="18" height="18" />
              </IconButton>
              <Flex
                direction="column"
                width={"100%"}
                style={{
                  background: "orange",
                  padding: "10px",
                  borderRadius: "5px",
                }}
                gap={"5"}
              >
                <CoinInfo name={toCoin} />
                <TextField.Root
                  size="3"
                  placeholder="Output amount"
                  value={toAmount}
                  onChange={(e) => setToAmount(Number(e.target.value))}
                />
              </Flex>

              <SwapButton from={fromCoin} to={toCoin} amount={fromAmount} />
            </Flex>
          </Card>
        </Box>
      </Flex>
    </Flex>
  );
};

export default Amm;
