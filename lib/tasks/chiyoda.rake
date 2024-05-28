namespace :chiyoda do
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
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=200',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=201',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=202',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=203',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=204',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=205',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=206',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=207',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=208',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=209',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=210',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=211',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=212',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=213',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=214',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=215',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=216',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=217',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=218',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=219',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=220',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=221',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=222',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=223',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=224',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=225',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=226',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=227',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=228',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=229',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=230',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=231',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=232',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=233',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=234',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=235',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=236',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=237',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=238',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=239',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=230',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=241',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=242',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=243',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=244',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=245',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=246',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=247',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=248',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=249',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=250',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=251',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=252',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=253',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=254',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=255',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=256',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=257',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=258',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=259',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=260',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=261',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=262',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=263',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=264',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=265',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=266',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=267',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=268',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=269',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=270',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=271',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=272',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=273',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=274',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=275',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=276',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=277',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=278',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=279',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=280',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=281',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=282',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=283',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=284',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=285',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=286',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=287',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=288',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=289',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=290',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=291',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=292',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=293',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=294',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=295',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=296',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=297',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=298',
      'https://www.chiyoda-med.or.jp/iryoukikan/byoin.php?id=299'
    ]

    urls.each do |url|
      driver.get(url)
      sleep 2 # ページが完全に読み込まれるのを待つ

      parsed_page = Nokogiri::HTML(driver.page_source)

      parsed_page.css('.clinictitle').each do |clinic|
        name = clinic.text.strip
        doctor_name = clinic.at_xpath('following-sibling::table//tr[th[contains(text(), "医師名")]]/td')&.text&.strip
        homepage_url = clinic.at_xpath('following-sibling::table//tr[th[contains(text(), "URL")]]/td/a')&.[]('href')
        email = clinic.at_xpath('following-sibling::table//td[@id="emd"]/a')&.text&.strip

        # 新しいテーブルにデータを保存
        next unless name || doctor_name || homepage_url || email

        Clinic.create(
          name:,
          email:,
          director_name: doctor_name,
          homepage_url:
        )
      end
    end

    driver.quit
  end
end
