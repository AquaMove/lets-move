module task_3_move_nft::task_3_move_nft{

        use std::string::{String};

    public struct PLNFT has key, store{
        id: UID,
        name: String,
        image_url: String,
        creator:address
    }

    fun init(ctx: &mut TxContext){

        let ntf = PLNFT{
            id:object::new(ctx),
            name:b"PhucLam NFT".to_string(),
            image_url: b"https://tapchibitcoin.io/wp-content/uploads/2023/04/Kucoin-tri-hoan-lich-ban-token-SUI-tapchibitcoin.jpg".to_string(),
            creator:ctx.sender()
        };
        transfer::transfer(ntf, ctx.sender());
    }


}
