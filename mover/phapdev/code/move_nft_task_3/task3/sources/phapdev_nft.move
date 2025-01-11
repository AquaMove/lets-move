module task3::phapdev_nft {

  use std::string::{Self, String};
  use sui::url::{Self, Url};

  public struct PHAPDEV_NFT has key, store {
     id: UID,
     name: String,
     image_url: Url,
     creator: address,
  }      

  // init PHAPDEV_NFT
  fun init(ctx: &mut TxContext) {
    let obj = PHAPDEV_NFT  {
      id: object::new(ctx),
      name: b"phapdev".to_string(),
      image_url: url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/SbTohmS8Me8CnO4E219evi0rGWbOWve3IcKeGTFv-I0"),
      creator: ctx.sender(),
    };

    transfer::transfer(obj, ctx.sender())
  }

  public entry fun mint(ctx: &mut TxContext) {
    transfer::transfer(PHAPDEV_NFT {
      id: object::new(ctx),
      name: b"phapdev".to_string(),
      image_url: url::new_unsafe_from_bytes(b"https://aggregator.walrus-testnet.walrus.space/v1/SbTohmS8Me8CnO4E219evi0rGWbOWve3IcKeGTFv-I0"),
      creator: ctx.sender(),
    }, ctx.sender())
  }
}
