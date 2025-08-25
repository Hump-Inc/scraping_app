# README

### タスク実行

1) まずスクレイプしてDBに保存
```
bundle exec rake scrape:save_data
```

2) DBからWXR(XML)を書き出し
```
bundle exec rake scrape:export_wxr
```

3) WP管理 > ツール > インポート > WordPress で XML をアップロード


### DBレコード一括削除
$ rails console
```
Datum.delete_all
```

### 一覧ページURL出力タスク
rails scrape:scrape_urls

### 医療ナビイ出力タスク
rails iryou:save_data

### アダルトサイト　スクレイピング MGS
1 )
```
DISABLE_SPRING=1 bin/rake "mgstage:collect_detail_urls[https://www.mgstage.com/search/cSearch.php?sale_start_range=2025.08.20-2025.08.20,tmp/urls.csv,5]"
```

2 ) 収集したURLから詳細CSVを作成（今まで通り）
```
DISABLE_SPRING=1 bin/rake "mgstage:detail_to_csv[tmp/urls.csv,tmp/mgs_detail.csv]"
```

3) WXRに変換して WordPress へインポート
```
DISABLE_SPRING=1 bin/rake "wp:csv_to_wxr[tmp/mgs_detail.csv,tmp/mgs_detail.xml,actress,admin]"
```

### アダルトサイト　スクレイピング FANZA
1)
```
FANZA_API_ID=6mcK7ZdepGGKpaUcdbN2 FANZA_AFFILIATE_ID=hisamasa5555-990 \
bundle exec rake "fanza:api_to_csv[1099472,tmp/fanza_detail.csv,1000]"
```


2) インポートファイル変換
```
bundle exec rake "fanza:csv_to_wxr[tmp/fanza_detail.csv,tmp/fanza_detail.wxr,https://fc2navi.click,admin]"
```


### SSH アクセス
```
ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes ypcuvemy@x019.cfbx.jp -p 22
```

# 重複削除
- ドライラン（削除予定だけ表示）:
```
wp --path=/home/ypcuvemy/public_html \
   fanza-dedupe run  --by=product_code --post_type=actress,post --status=publish --keep=oldest --dry-run=1
```

- 本番重複コンテンツ削除（古い方を残す設定）
```
wp --path=/home/ypcuvemy/public_html \
   fanza-dedupe run  --by=product_code --post_type=actress,post --status=publish --keep=oldest
```

