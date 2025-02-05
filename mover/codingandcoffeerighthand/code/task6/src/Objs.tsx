import { useSuiClientQuery } from "@mysten/dapp-kit"

interface ObjsProps {
    addr: string
}
export function Objs({ addr }: ObjsProps) {
    const { data } = useSuiClientQuery("getOwnedObjects", { owner: addr })
    return (
        <ul>
            {data?.data.map(obj => (
                <li key={obj.data?.objectId}>
                    {obj.data?.objectId}
                </li>
            ))}
        </ul>
    )
}