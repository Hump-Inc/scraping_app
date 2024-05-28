namespace :iryou do
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
      ''
    ]

    urls.each do |url|
      driver.get(url)
      sleep 2 # ページが完全に読み込まれるのを待つ

      parsed_page = Nokogiri::HTML(driver.page_source)

      # カタカナの正式名称を取得
      official_name_kana = parsed_page.at_xpath('//th/label[contains(text(), "正式名称（フリガナ）")]/../following-sibling::td/div/label')&.text&.strip

      # 漢字の正式名称を取得
      official_name_kanji = parsed_page.at_xpath('//th/label[contains(text(), "正式名称") and not(contains(text(), "（フリガナ）"))]/../following-sibling::td/div/label')&.text&.strip

      # 郵便番号を正しく取得
      postal_code = parsed_page.at_xpath('//th/label[contains(text(), "郵便番号")]/../following-sibling::td/div/label')&.text&.strip

      # 電話番号を取得
      phone_number = parsed_page.at_xpath('//th/label[contains(text(), "案内用電話番号")]/../following-sibling::td/div/label/a')&.text&.strip

      address_with_postal_code = parsed_page.at_xpath('//th/label[contains(text(), "所在地")]/../following-sibling::td/div/label')&.text&.strip
      address = begin
        address_with_postal_code.sub(/〒\d{3}-\d{4}/, '').strip
      rescue StandardError
        nil
      end
      fax = parsed_page.at_xpath('//th/label[contains(text(), "案内用ファクシミリ番号")]/../following-sibling::td/div/label')&.text&.strip
      website = parsed_page.at_xpath('//th/label[contains(text(), "案内用ホームページアドレス")]/../following-sibling::td/div/label/a')&.[]('href')
      email = parsed_page.at_xpath('//th/label[contains(text(), "案内用電子メールアドレス")]/../following-sibling::td/div/label/a')&.text&.strip

      # 診療科目を取得
      special_notes = parsed_page.xpath('//label/strong[contains(text(), "◆")]/text()').map(&:text).map(&:strip).join(', ')

      # データの保存
      unless official_name_kanji || official_name_kana || postal_code || phone_number || address || fax || website || email || special_notes || subjects
        next
      end

      MedicalInstitution.create(
        official_name: official_name_kanji,
        official_name_kana:,
        postal_code:,
        phone_number:,
        address:,
        fax:,
        website:,
        email:,
        special_notes:
      )
    end

    driver.quit
  end
end
