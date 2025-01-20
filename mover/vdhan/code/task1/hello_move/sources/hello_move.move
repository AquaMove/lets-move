// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

/// Module: hello_move
module hello_move::hello_move {
    use std::string::{String};

    public struct Hello_vdhan has key {
        id: UID,
        name: String
    }

    entry fun shoutout_vdhan(ctx: &mut TxContext) {
        let hello_world = Hello_vdhan {
            id: object::new(ctx),
            name: b"Hello vdhan".to_string()
        };

        transfer::transfer(hello_world, tx_context::sender(ctx));
    }
}
