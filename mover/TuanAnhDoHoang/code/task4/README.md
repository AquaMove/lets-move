game:
    randomness
    win/loss
    pool
    deposit/withdraw


(ok)Số coin đó phải tối thiểu là 5 coin để tham gia trò chơi
(ok)Người chơi sẽ nắm giữ một số coin nhất định
(ok)Người chơi có thể nạp thêm coin
(ok)Người chơi có thể rút coin đi nếu vẫn chưa đưa vào pool 

Tương tác giữa người chơi và pool



mô tả game
tạo coin
(ok)faucet cho một ít coin làm vốn
player sẽ phải gửi một số coin vào pool để tham gia trò chơi
coin trong pool không rút ra được, chỉ có thể chuyển tiền đến người chơi bằng faucet 


senorior:
faucet cho người chơi 5 coin
người chơi có thể dùng "split coin" để dùng số coin muốn nạp vào pool để tham gia trò chơi bằng hàm "player_deposit_coin"
người chơi dùng hàm "play_game" để kiểm tra và chơi game
nếu thắng, số tiền sẽ được cộng 2 coin và chuyển về toàn bộ cho người chơi cả gốc lẫn lãi
nếu thua thì ngược lại