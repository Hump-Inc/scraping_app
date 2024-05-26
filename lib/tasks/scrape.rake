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
      "https://job-medley.com/mc/pref13/?page=2",
      "https://job-medley.com/mc/pref13/?page=3",
      "https://job-medley.com/mc/pref13/?page=4",
      "https://job-medley.com/mc/pref13/?page=5",
      "https://job-medley.com/mc/pref13/?page=6",
      "https://job-medley.com/mc/pref13/?page=7",
      "https://job-medley.com/mc/pref13/?page=8",
      "https://job-medley.com/mc/pref13/?page=9",
      "https://job-medley.com/mc/pref13/?page=10",
      "https://job-medley.com/mc/pref13/?page=11",
      "https://job-medley.com/mc/pref13/?page=12",
      "https://job-medley.com/mc/pref13/?page=13",
      "https://job-medley.com/mc/pref13/?page=14",
      "https://job-medley.com/mc/pref13/?page=15",
      "https://job-medley.com/mc/pref13/?page=16",
      "https://job-medley.com/mc/pref13/?page=17",
      "https://job-medley.com/mc/pref13/?page=18",
      "https://job-medley.com/mc/pref13/?page=19",
      "https://job-medley.com/mc/pref13/?page=20",
      "https://job-medley.com/mc/pref13/?page=21",
      "https://job-medley.com/mc/pref13/?page=22",
      "https://job-medley.com/mc/pref13/?page=23",
      "https://job-medley.com/mc/pref13/?page=24",
      "https://job-medley.com/mc/pref13/?page=25",
      "https://job-medley.com/mc/pref13/?page=26",
      "https://job-medley.com/mc/pref13/?page=27",
      "https://job-medley.com/mc/pref13/?page=28",
      "https://job-medley.com/mc/pref13/?page=29",
      "https://job-medley.com/mc/pref13/?page=30",
      "https://job-medley.com/mc/pref13/?page=31",
      "https://job-medley.com/mc/pref13/?page=32",
      "https://job-medley.com/mc/pref13/?page=33",
      "https://job-medley.com/mc/pref13/?page=34",
      "https://job-medley.com/mc/pref13/?page=35",
      "https://job-medley.com/mc/pref13/?page=36",
      "https://job-medley.com/mc/pref13/?page=37",
      "https://job-medley.com/mc/pref13/?page=38",
      "https://job-medley.com/mc/pref13/?page=39",
      "https://job-medley.com/mc/pref13/?page=40",
      "https://job-medley.com/mc/pref13/?page=41",
      "https://job-medley.com/mc/pref13/?page=42",
      "https://job-medley.com/mc/pref13/?page=43",
      "https://job-medley.com/mc/pref13/?page=44",
      "https://job-medley.com/mc/pref13/?page=45",
      "https://job-medley.com/mc/pref13/?page=46",
      "https://job-medley.com/mc/pref13/?page=47",
      "https://job-medley.com/mc/pref13/?page=48",
      "https://job-medley.com/mc/pref13/?page=49",
      "https://job-medley.com/mc/pref13/?page=50",
      "https://job-medley.com/mc/pref13/?page=51",
      "https://job-medley.com/mc/pref13/?page=52",
      "https://job-medley.com/mc/pref13/?page=53",
      "https://job-medley.com/mc/pref13/?page=54",
      "https://job-medley.com/mc/pref13/?page=55",
      "https://job-medley.com/mc/pref13/?page=56",
      "https://job-medley.com/mc/pref13/?page=57",
      "https://job-medley.com/mc/pref13/?page=58",
      "https://job-medley.com/mc/pref13/?page=59",
      "https://job-medley.com/mc/pref13/?page=60",
      "https://job-medley.com/mc/pref13/?page=61",
      "https://job-medley.com/mc/pref13/?page=62",
      "https://job-medley.com/mc/pref13/?page=63",
      "https://job-medley.com/mc/pref13/?page=64",
      "https://job-medley.com/mc/pref13/?page=65",
      "https://job-medley.com/mc/pref13/?page=66",
      "https://job-medley.com/mc/pref13/?page=67",
      "https://job-medley.com/mc/pref13/?page=68",
      "https://job-medley.com/mc/pref13/?page=69",
      "https://job-medley.com/mc/pref13/?page=70",
      "https://job-medley.com/mc/pref13/?page=71",
      "https://job-medley.com/mc/pref13/?page=72",
      "https://job-medley.com/mc/pref13/?page=73",
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
