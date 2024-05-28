namespace :omori do
  desc 'Webサイトからデータを抽出し、DBに保存する'
  task save_data: :environment do
    require 'webdrivers'
    require 'selenium-webdriver'
    require 'nokogiri'

    Webdrivers::Chromedriver.update

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1280x800')

    driver = Selenium::WebDriver.for(:chrome, options:)

    urls = [
      'https://www.omori-med.or.jp/detail/%E3%82%A2%E3%82%A4%E3%83%A1%E3%83%87%E3%82%A3%E3%82%AB%E3%83%AB%E3%82%AF%E3%83%AA%E3%83%8B%E3%83%83%E3%82%AF'
    ]

    urls.each do |url|
      driver.get(url)
      sleep 2 # ページが完全に読み込まれるのを待つ

      parsed_page = Nokogiri::HTML(driver.page_source)

      parsed_page.css('article').each do |clinic|
        name = clinic.at_css('h5')&.text&.strip
        director_name = clinic.at_xpath('.//tr[th[contains(text(), "院長")]]/td')&.text&.strip
        homepage_url = clinic.at_xpath('.//tr[th[contains(text(), "ホームページ")]]/td/a')&.[]('href')
        email = clinic.at_xpath('.//tr[th[contains(text(), "E-mail")]]/td')&.text&.strip

        # E-mailのJavaScriptで生成される部分を処理
        email_script = clinic.at_xpath('.//tr[th[contains(text(), "E-mail")]]/td/script')
        if email_script
          email = email_script.text.match(/mailto:(.*?)"/)[1]
          email = email.gsub('(at)', '@').gsub('(dot)', '.')
        end

        # 新しいテーブルにデータを保存
        next unless name || director_name || homepage_url || email

        Clinic.create(
          name:,
          email:,
          director_name:,
          homepage_url:
        )
      end
    end

    driver.quit
  end
end
