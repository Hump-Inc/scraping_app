namespace :scrape do
  desc "Webサイトからデータを抽出し、DBに保存する"
  task :save_data => :environment do
    require 'nokogiri'
    require 'httparty'

    # 複数のURLをセット
    urls = [
      "https://job-medley.com/mc/pref12/",
      "https://job-medley.com/mc/pref12/?page=2",
      "https://job-medley.com/mc/pref12/?page=3",
      "https://job-medley.com/mc/pref12/?page=4",
      "https://job-medley.com/mc/pref12/?page=5",
      "https://job-medley.com/mc/pref12/?page=6",
      "https://job-medley.com/mc/pref12/?page=7",
      "https://job-medley.com/mc/pref12/?page=8",
      "https://job-medley.com/mc/pref12/?page=9",
      "https://job-medley.com/mc/pref12/?page=10",
      "https://job-medley.com/mc/pref12/?page=11",
      "https://job-medley.com/mc/pref12/?page=12",
      "https://job-medley.com/mc/pref12/?page=13",
      "https://job-medley.com/mc/pref12/?page=14",
      "https://job-medley.com/mc/pref12/?page=15",
      "https://job-medley.com/mc/pref12/?page=16",
      "https://job-medley.com/mc/pref12/?page=17",
      "https://job-medley.com/mc/pref12/?page=18",
      "https://job-medley.com/mc/pref12/?page=19",
      # "https://job-medley.com/mc/pref12/?page=20",
      # "https://job-medley.com/mc/pref12/?page=21",
      # "https://job-medley.com/mc/pref12/?page=22",
    ]

    urls.each do |url|

      unparsed_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(unparsed_page)
  
      # ここで抽出する要素に応じて変更してください
      parsed_page.css('.o-gutter-row__item').each do |row|
        name = row.css('a.js-link-extender__target').text.strip
        address_elements = row.css('p.c-job-offer-card__table-td-txt')
      
        # 「東京都」を含む住所を検索する正しい方法
        address = nil
        address_elements.each do |element|
          if element.text.include?("千葉県")
            address = element.text.strip
            break # 最初に見つかった「東京都」を含む住所を使用
          end
        end
      
        # DBに保存する条件を満たす場合のみ保存
        Datum.create(name: name, address: address) if address
      end
    end
    
  end
end
