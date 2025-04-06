module eve_project::eve_token {
    use sui::coin::{Coin, create_currency, mint};
    use sui::url;

    public struct EVE has store, copy, drop {}

    public entry fun mint_eve(ctx: &mut TxContext) {
        let name = b"EVE";
        let symbol = b"EVE";
        let description = b"Eve the rabbit fighting kidney disease.";
        let decimals: u8 = 6;

        // NOTE: 一旦空にする
        let icon_url = option::none<url::Url>();
        let witness = EVE {};

        let (mut treasury_cap, metadata) = create_currency<EVE>(
            witness,
            decimals,
            symbol,
            name,
            description,
            icon_url,
            ctx
        );

        let amount: u64 = 999_999_999; // 9億
        let coin: Coin<EVE> = mint(&mut treasury_cap, amount, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));

        // 発行数を固定にする事を明確にするため、TreasuryCap<T>は闇に葬る(誰もmint, burn出来ない)
        let blackhole: address = @0x0;
        transfer::public_transfer(treasury_cap, blackhole);
 
        // メタ情報をプロジェクトアドレスへ転送する
        let storage_addr: address = @eve_project;
        transfer::public_transfer(metadata, storage_addr);
    }
}