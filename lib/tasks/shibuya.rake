namespace :shibuya do
  desc 'Webサイトからデータを抽出し、DBに保存する'
  task save_data: :environment do
    require 'nokogiri'
    require 'httparty'

    urls = [
      'https://sby.tokyo.med.or.jp/institution/page/2/',
      'https://sby.tokyo.med.or.jp/institution/page/3/',
      'https://sby.tokyo.med.or.jp/institution/page/4/',
      'https://sby.tokyo.med.or.jp/institution/page/5/',
      'https://sby.tokyo.med.or.jp/institution/page/6/',
      'https://sby.tokyo.med.or.jp/institution/page/7/',
      'https://sby.tokyo.med.or.jp/institution/page/8/',
      'https://sby.tokyo.med.or.jp/institution/page/9/',
      'https://sby.tokyo.med.or.jp/institution/page/10/',
      'https://sby.tokyo.med.or.jp/institution/page/11/',
      'https://sby.tokyo.med.or.jp/institution/page/12/',
      'https://sby.tokyo.med.or.jp/institution/page/13/',
      'https://sby.tokyo.med.or.jp/institution/page/14/',
      'https://sby.tokyo.med.or.jp/institution/page/15/',
      'https://sby.tokyo.med.or.jp/institution/page/16/'

    ]

    urls.each do |url|
      unparsed_page = HTTParty.get(url)
      next if unparsed_page.body.nil? || unparsed_page.body.empty?

      parsed_page = Nokogiri::HTML(unparsed_page.body)

      parsed_page.css('.institution_list').each do |clinic|
        name = clinic.at_css('.institution_tit')&.text&.strip
        email = clinic.at_css('dl:contains("メール") dd a')&.text&.strip
        homepage_url = clinic.at_css('dl:contains("ホームページ") dd a')&.[]('href')

        # 新しいテーブルにデータを保存
        next unless name || email || homepage_url

        Clinic.create(
          name:,
          email:,
          homepage_url:
        )
      end
    end
  end
end
