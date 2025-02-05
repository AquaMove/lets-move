import { useSignAndExecuteTransaction } from "@mysten/dapp-kit"
import { Transaction } from "@mysten/sui/transactions"
import { useState } from "react"

export function SendSui() {
    const { mutateAsync } = useSignAndExecuteTransaction()
    const [digest, setDigest] = useState<string>("")
    function sendMessage() {
        const txb = new Transaction()
        const coin = txb.splitCoins(txb.gas, [1])
        txb.transferObjects([coin], '0xe5de6cf1e90843e9ad11bf51f0c33a04b27249a31c067e5488bf7011accadbd1')
        txb.moveCall({
            target: "0xf11589cdcd0cfb55573861d82dcc8140cdf3cabc9c03681c26f1bdbdc17d705b::hello_move::say_hello_codingandcoffeerighthand",
        })
        mutateAsync({
            transaction: txb,
        }).then(async (result) => {
            alert("sui sent ok")
            console.info(result)
            setDigest(result.digest)
        })
    }
    return (
        <div>
            <p>Digest: {digest}</p>
            <button onClick={sendMessage}>Send SUI</button>
        </div>
    )
}