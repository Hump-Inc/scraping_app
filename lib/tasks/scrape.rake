require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'

namespace :scrape do
  desc 'Scrape detail page URLs from the given index pages'
  task scrape_urls: :environment do
    index_urls = [
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=1&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=2&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=3&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=4&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=5&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=6&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=7&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=8&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=9&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=10&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=11&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=12&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=13&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=14&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=15&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=16&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=17&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=18&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=19&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=20&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=21&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=22&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=23&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=24&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=25&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=26&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=27&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=28&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=29&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=30&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=31&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=32&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=33&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=34&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=35&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=36&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=37&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=38&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=39&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=40&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=41&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=42&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=43&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=44&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=45&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=46&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=47&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=48&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=49&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=50&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=51&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=52&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=53&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=54&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=55&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=56&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=57&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=58&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=59&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=60&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=61&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=62&size=20&sortNo=1',
      'https://www.iryou.teikyouseido.mhlw.go.jp/znk-web/juminkanja/S2400/initialize/%E5%A4%A7%E5%88%86%E7%9C%8C/?sjk=1&page=63&size=20&sortNo=1',
    ]
    all_detail_urls = []

    user_agents = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:55.0) Gecko/20100101 Firefox/55.0',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.1 Safari/602.3.12'
    ]

    index_urls.each do |index_url|
      uri = URI(index_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request['User-Agent'] = user_agents.sample

      response = http.request(request)
      doc = Nokogiri::HTML(response.body)

      detail_links = doc.css('.resultItems .item h3.name a')
      detail_urls = detail_links.map { |link| "'#{URI.join(index_url, link['href'])}'" }
      all_detail_urls.concat(detail_urls)

      sleep rand(5..10) # リクエスト間にランダムな遅延を追加
    rescue OpenURI::HTTPError => e
      puts "An error occurred while trying to fetch the URL: #{e.message}"
    rescue StandardError => e
      puts "An unexpected error occurred: #{e.message}"
    end

    # カンマ区切りの形式でURLを結合
    urls_csv = all_detail_urls.join(',')
    ScrapedDatum.create(urls: urls_csv)
    puts 'Scraped URLs have been saved to the database.'
  end
end
