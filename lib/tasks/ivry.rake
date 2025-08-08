namespace :ivry do
  desc 'ivry.jpからクリニック情報を抽出してDBに保存'
  task save_data: :environment do
    require 'webdrivers'
    require 'selenium-webdriver'
    require 'nokogiri'

    Webdrivers::Chromedriver.update

    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1280x800')

    driver = Selenium::WebDriver.for(:chrome, options:)

    # ページネーションも対応する場合はこのURLに ?page=n をつけてループさせる
    base_url = 'https://ivry.jp/telsearch/category/%E5%8C%BB%E7%99%82%E3%83%BB%E5%81%A5%E5%BA%B7%E3%83%BB%E4%BB%8B%E8%AD%B7/'
    driver.get(base_url)

    # HTMLを保存して目視確認
    sleep 10 # JavaScriptでのレンダリング猶予
    File.write("debug_ivry.html", driver.page_source)
    puts "✅ Saved page source to debug_ivry.html"

    # セレクタが見つかるか確認
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    wait.until do
      elements = driver.find_elements(css: '[class^="PhoneNumberCardList_card"]')
      puts "⏳ Trying to find cards... found #{elements.count}"
      elements.any?
    end

    cards.each do |card|
      name = card.at_css('.PhoneNumberCardList_info__pBkD7')&.text&.strip
      phone_number = card.at_css('.PhoneNumberCardList_phoneNumber__jbC1s')&.text&.strip

      labels = card.css('.PhoneNumberCardList_labelList__XtAEd .PhoneNumberCardList_label__HAzuS').map(&:text).map(&:strip)
      label_text = labels.join(', ')

      next if name.blank? && phone_number.blank?

      puts "Saving: #{name}, #{phone_number}, labels: #{label_text}"

      MedicalInstitution.create!(
        official_name: name,
        phone_number: phone_number,
        email: nil, # emailはこのページにはない
        tag: label_text # 任意でカラム追加してください（例: tag カラム）
      )
    end

    driver.quit
  end
end
