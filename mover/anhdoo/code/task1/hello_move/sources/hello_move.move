/*
/// Module: hello_move
module hello_move::hello_move;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module hello_move::hello_move{
    use std::string;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct TuanAnhDoHoang has key{
        id: UID,
        name: string::String 
    }

    public fun say_hello_TuanAnhDoHoang(ctx: &mut TxContext){
        let gitHubId = TuanAnhDoHoang{
            id: object::new(ctx),
            name: b"hello TuanAnhDoHoang".to_string()
        };
        transfer::transfer(gitHubId,ctx.sender());
    } 
}

