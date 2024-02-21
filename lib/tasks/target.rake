namespace :target do
  desc "Webサイトからデータを抽出し、DBに保存する"
  task :save_data => :environment do
    require 'nokogiri'
    require 'httparty'

    url = "https://job-medley.com/mc/pref13/?page=6"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)

    # ここで抽出する要素に応じて変更してください
    parsed_page.css('.o-gutter-row__item').each do |row|
      name = row.css('a.js-link-extender__target').text.strip
      address_elements = row.css('p.c-job-offer-card__table-td-txt')
      
      # 「東京都」を含む住所を検索する正しい方法
      address = nil
      address_elements.each do |element|
        if element.text.include?("東京都")
          address = element.text.strip
          break # 最初に見つかった「東京都」を含む住所を使用
        end
      end

      # DBに保存する
      Datum.create(name: name, address: address) if address
    end
  end
end
