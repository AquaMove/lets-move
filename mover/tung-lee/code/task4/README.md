export package=0xc7b478a89da0223ef0128813ecb817e894e1f4be3e586e13dfe09a37c9b358db

export admin=0xaba4c4ebabb37bb7bad86876d6b56eb47f14d94748e5350375ebad3bf0e92c34

export game=0xb0be81ee8d0bf831544c36ba1b0a3bcfec5de6406c710b0f276aee00b841aa4b

export treasury=0xef03993866da80885af37187dac49fbeef2725c3ee9305d10da3aa06aa23a96a

sui client call --package $package --module faucet_coin --function mint_token --args $treasury 100000000000

faucet_coin_obj=0xf5f9cc1cc6f4ca7f05a1cdfa40836de97765ae9191ec4ea263c840c9fc7de5e2

0xb80ca451deb0d265631b14d62049a6a98e29208c9db88b172d1f7781c887c9c3

sui client call --package $package --module task4 --function deposit --args $game 0xf5f9cc1cc6f4ca7f05a1cdfa40836de97765ae9191ec4ea263c840c9fc7de5e2 100000

Deposit hash: 5W5bfETCwoReTDNpNNvtogqmF52dHZMq1fKmuZ3LA4dw

sui client object $game

sui client call --package $package --module task4 --function withdraw --args $game $admin 100000

Withdraw hash: 

H3Rvg3pw6Gert2TTcsv3wNFf1i6vrdYBojHC4tQ2QGBd

sui client object $game

sui client call --package $package --module task4 --function play --args $game 0x8 true 0xb80ca451deb0d265631b14d62049a6a98e29208c9db88b172d1f7781c887c9c3

Play hash: 2uKyn1zWQSy46qmxsvqz6mgimWaHDEBWTskWJNvWJBKC