# frozen_string_literal: true
require "httpx"
require "nokogiri"

class IvryEmailScraper
  BASE_URL = "https://ivry.jp"

  EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i

  def initialize(category_path:)
    @category_url = "#{BASE_URL}#{category_path}"
  end

  def call
    clinic_pages = extract_clinic_pages
    puts "▶ 施設詳細ページ数: #{clinic_pages.size}"

    site_urls = Parallel.map(clinic_pages, in_threads: 10) { |url| extract_official_site(url) }.compact
    puts "▶ 公式サイトURL数: #{site_urls.size}"

    emails = Parallel.map(site_urls, in_threads: 20) { |url| find_emails_in_site(url) }.flatten.uniq
    puts "▶ 抽出メール数: #{emails.size}"

    emails
  end

  private

  # ①一覧ページから施設詳細ページを取得
  def extract_clinic_pages
    html = HTTPX.get(@category_url).to_s
    doc  = Nokogiri::HTML.parse(html)
    doc.css('a.telsearch-result__name').map { |a| BASE_URL + a['href'] }
  end

  # ②各詳細ページから「公式HP」リンクを拾う
  def extract_official_site(detail_url)
    html = HTTPX.get(detail_url).to_s
    doc  = Nokogiri::HTML.parse(html)
    link = doc.at_css('a[href^="http"]:contains("公式")')
    link&.[]('href')
  end

  # ③公式サイト全体を shallow クロールしてメールを探す
  def find_emails_in_site(root_url, depth = 1)
    urls_to_visit = [root_url]
    visited       = {}
    found         = []

    while urls_to_visit.any? && depth >= 0
      url = urls_to_visit.shift
      next if visited[url]
      visited[url] = true

      body = HTTPX.get(url, timeout: 10).to_s rescue next
      found += body.scan(EMAIL_REGEX)

      next unless depth > 0
      doc = Nokogiri::HTML.parse(body)
      doc.css('a[href^="/"], a[href^="' + root_url + '"]').each do |a|
        href = a['href']
        next unless href
        absolute = href.start_with?('http') ? href : URI.join(root_url, href).to_s
        urls_to_visit << absolute unless visited[absolute]
      end
    end
    found
  end
end
