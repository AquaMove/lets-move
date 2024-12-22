module hello_move::mover;

use std::string::{Self, String};

public struct Mover has key, store {
    id: UID,
    github_id: String,
}

fun init(ctx: &mut TxContext) {
    let mover = Mover {
        id: object::new(ctx),
        github_id: string::utf8(b"minhnd410"),
    };

    transfer::transfer(mover, ctx.sender());
}

public fun github_id(self: &Mover): String {
    self.github_id
}

#[test]
fun test_mover() {
    use sui::test_scenario;

    let admin = @0xAD;

    let mut scenario = test_scenario::begin(admin);
    {
        init(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let mover = scenario.take_from_sender<Mover>();
        // Verify number of created swords
        assert!(mover.github_id() == string::utf8(b"minhnd410"), 1);
        // Return the Forge object to the object pool
        scenario.return_to_sender(mover);
    };
    
    scenario.end();
}