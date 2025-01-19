module 0x0::nft{
    use std::string::{Self, String};
    use sui::url::{Self, Url};

    public struct MenhNFT has key, store{
      id: UID,
      name: String,
      img_url: Url,
      creator: address,
      }

      fun init(ctx: &mut TxContext){
          let nft_obj = MenhNFT {
              id: object::new(ctx),
              name: b"Menh NFT".to_string(),
              img_url: url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/goer14XHRu1oeX_8MPRtTT9yaXjXdaJAV1-Jzn2ZG2c"),
              creator: ctx.sender()
            };
            transfer::transfer(nft_obj, ctx.sender());
        }

      public entry fun mint_nft(ctx: &mut TxContext){
          transfer::transfer( MenhNFT {
              id: object::new(ctx),
              name: b"Menh NFT".to_string(),
              img_url: url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/goer14XHRu1oeX_8MPRtTT9yaXjXdaJAV1-Jzn2ZG2c"),
              creator: ctx.sender()
            }, ctx.sender())
        }

      public entry fun transfer_nft(
        nft: MenhNFT,
        recipient: address,
        ctx: &mut TxContext
      ){
          transfer::transfer(nft, recipient);
        }
  }
