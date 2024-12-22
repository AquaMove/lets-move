module move_game::game_counter;

use sui::bcs::{Self};

public struct GameCounter has key {
  id: UID,
  github_id: vector<u8>,
  count: u64,
}

public fun mint(ctx: &mut TxContext): GameCounter {
  GameCounter {
    id: object::new(ctx),
    count: 0,
    github_id: b"minhnd410"
  }
}

public fun transfer_to_sender(counter: GameCounter, ctx: &mut TxContext) {
  transfer::transfer(counter, tx_context::sender(ctx));
}

public fun get_vrf_input_and_increment(self: &mut GameCounter): vector<u8> {
  let mut vrf_input = object::id_bytes(self);
  let count_to_bytes = bcs::to_bytes(&count(self));
  vrf_input.append(count_to_bytes);
  self.increment();
  vrf_input
}

public fun count(self: &GameCounter): u64 {
  self.count
}

// === Internal ===

fun increment(self: &mut GameCounter) {
  self.count = self.count + 1;
}
