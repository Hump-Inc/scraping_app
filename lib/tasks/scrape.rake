namespace :scrape do
  desc "Webサイトからデータを抽出し、DBに保存する"
  task :save_data => :environment do
    require 'nokogiri'
    require 'httparty'

    # 住所のクリーンアップ用メソッド
    def clean_address(address)
      # 正規表現を使用して「徒歩」以降のテキストを取り除く
      address.gsub(/ .*徒歩.*/, '')
      # 最初のスペース（全角スペースを含む）以降を削除
      # address.split(/ | /, 2).first
    end

    # nameのクリーンアップ用メソッド
    def clean_name(name)
      name.split('の').first
    end

    urls = [
      "https://job-medley.com/mc/pref13/",
      # その他のURL
    ]

    urls.each do |url|
      unparsed_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(unparsed_page)

      parsed_page.css('.o-gutter-row__item').each do |row|
        name = row.css('a.js-link-extender__target').text.strip
        address_elements = row.css('p.c-job-offer-card__table-td-txt')

        address = nil
        address_elements.each do |element|
          if element.text.include?("東京都")
            # 住所のクリーンアップ処理を適用
            address = clean_address(element.text.strip)
            break
          end
        end

        # 住所から郵便番号を検索
        # postal_code = find_postal_code(address) if address

        # nameのクリーニング
        cleaned_name = clean_name(name)

        # 条件を満たす場合のみDBに保存
        Datum.create(name: cleaned_name, address: address) if address
      end
    end
  end
end

