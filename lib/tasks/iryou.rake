namespace :iryou do
  desc 'Webサイトからクリニック名・電話・メールを抽出し、DBに保存する'
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
      
    ]

    urls.each do |url|
      driver.get(url)
      sleep 2

      parsed_page = Nokogiri::HTML(driver.page_source)

      # 必要な情報のみ抽出
      clinic_name = parsed_page.at_xpath('//th/label[contains(text(), "正式名称") and not(contains(text(), "（フリガナ）"))]/../following-sibling::td/div/label')&.text&.strip
      phone_number = parsed_page.at_xpath('//th/label[contains(text(), "案内用電話番号")]/../following-sibling::td/div/label/a')&.text&.strip
      email = parsed_page.at_xpath('//th/label[contains(text(), "案内用電子メールアドレス")]/../following-sibling::td/div/label/a')&.text&.strip

      next if clinic_name.blank? && phone_number.blank? && email.blank?

      MedicalInstitution.create(
        official_name: clinic_name,
        phone_number:,
        email:
      )
    end

    driver.quit
  end
end
