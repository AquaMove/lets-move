module tương tác swap_coin
dùng hàm mint_coins để khởi tạo ban đầu: tạo 50 coin usdt và 50 coin anhdoo cho người dùng
public fun mint_coins(treasury1: &mut TreasuryCap<USDT>,treasury2: &mut TreasuryCap<ANHDOO>, pool: &mut Liquidity_Pool,  ctx:&mut TxContext){

dùng hai hàm để tương tác
swap_coin_USDT_ANHDOO(pool: &mut Liquidity_Pool, amount: Coin<USDT> , ctx: &mut TxContext)
swap_coin_ANHDOO_USDT(pool: &mut Liquidity_Pool, amount: Coin<ANHDOO> , ctx: &mut TxContext)
