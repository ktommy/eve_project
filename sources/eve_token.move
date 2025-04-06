module eve_project::eve_token {
    use sui::coin::{Coin, create_currency, mint};
    use sui::url;

    public struct EVE2 has store, copy, drop {}

    public entry fun mint_eve(ctx: &mut TxContext) {
        let name = b"EVE2";
        let symbol = b"EVE2";
        let description = b"Eve the rabbit fighting kidney disease.";
        let decimals: u8 = 6;

        // NOTE: 一旦空にする
        let icon_url = option::none<url::Url>();
        let witness = EVE2 {};

        let (mut treasury_cap, metadata) = create_currency<EVE2>(
            witness,
            decimals,
            symbol,
            name,
            description,
            icon_url,
            ctx
        );

        let amount: u64 = 999_999_999; // 9億
        let coin: Coin<EVE2> = mint(&mut treasury_cap, amount, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));

        let blackhole: address = @0x0;
        transfer::public_transfer(treasury_cap, blackhole);
 
        // メタ情報をプロジェクトアドレスへ転送する
        let storage_addr: address = @eve_project;
        transfer::public_transfer(metadata, storage_addr);
    }
}
