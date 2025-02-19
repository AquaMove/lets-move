module letter::letter {
    use std::string::String;

    public struct Letter has key, store {
        id: UID,
        title: String,
        from: address,
        message: String,
        timestamp: u64
    }

    public entry fun send_a_letter(title: String, message: String, to: address, timestamp: u64, ctx: &mut TxContext) {
        let letter = Letter {
            id: object::new(ctx),
            title,
            from: ctx.sender(),
            message,
            timestamp,
        };

        transfer::transfer(letter, to);
    }
}