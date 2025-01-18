import CoinButton from "./CoinButton";
import CoinInfo from "./CoinInfo";

interface IProps {
  name: string;
}
const CoinBlock = ({ name }: IProps) => {
  return (
    <div className="flex flex-col hover:shadow-xl px-4 pt-5 pb-8 gap-y-4 border rounded-2xl shadow-lg bg-white">
      <CoinInfo name={name} />
      {/* <input
        type="number"
        placeholder="Enter amount"
        className="block w-full pr-4 text-black py-2 bg-transparent rounded-lg sm:text-base focus:outline-none focus:border-0"
      /> */}
      <CoinButton />
    </div>
  );
};

export default CoinBlock;
