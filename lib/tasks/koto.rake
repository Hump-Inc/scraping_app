namespace :koto do
  desc 'Webサイトからデータを抽出し、DBに保存する'
  task save_data: :environment do
    require 'nokogiri'
    require 'httparty'

    # nameのクリーンアップ用メソッド
    def clean_name(name)
      name.split('の').first
    end

    urls = [
      'https://koto-med.or.jp/medicine/%e3%82%82%e3%82%93%e3%81%aa%e3%81%8b%e6%b3%8c%e5%b0%bf%e5%99%a8%e7%a7%91',
    ]

    urls.each do |url|
      unparsed_page = HTTParty.get(url)
      next if unparsed_page.body.nil? || unparsed_page.body.empty?

      parsed_page = Nokogiri::HTML(unparsed_page.body)

      parsed_page.css('#contents .page_src_details').each do |clinic|
        name = clinic.css('h2').text.strip
        email = clinic.at_css('tr:contains("メールアドレス") td')&.text&.strip
        director_name = clinic.at_css('tr:contains("院長名") td')&.text&.strip
        homepage_url = clinic.at_css('tr:contains("ホームページ") td a')&.[]('href')

        # nameのクリーニング
        cleaned_name = clean_name(name)

        # 新しいテーブルにデータを保存
        next unless email || director_name || homepage_url

        Clinic.create(
          name: cleaned_name,
          email:,
          director_name:,
          homepage_url:
        )
      end
    end
  end
end
