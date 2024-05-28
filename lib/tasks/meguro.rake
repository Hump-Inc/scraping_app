namespace :meguro do
  desc 'Webサイトからデータを抽出し、DBに保存する'
  task save_data: :environment do
    require 'nokogiri'
    require 'httparty'

    # nameのクリーンアップ用メソッド
    def clean_name(name)
      name.split('の').first
    end

    urls = [
      'https://www.meguroku-med.jp/health-examination_list/details04/1311029610.html',
    ]

    urls.each do |url|
      unparsed_page = HTTParty.get(url)
      next if unparsed_page.body.nil? || unparsed_page.body.empty?

      parsed_page = Nokogiri::HTML(unparsed_page.body)

      parsed_page.css('#left-content').each do |clinic|
        name = clinic.at_xpath('.//tr[td[contains(text(), "医療機関")]]/td[2]')&.text&.strip
        email = clinic.at_xpath('.//tr[td[contains(text(), "窓口となるメールアドレス")]]/td[2]/a')&.text&.strip
        director_name = clinic.at_xpath('.//tr[td[contains(text(), "管理者名")]]/td[2]')&.text&.strip
        homepage_url = clinic.at_xpath('.//tr[td[contains(text(), "ホームページアドレス")]]/td[2]/a')&.[]('href')

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
