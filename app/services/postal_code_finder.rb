require 'rest-client'
require 'json'

class PostalCodeFinder
  def self.find_postal_code(address)
    base_url = "https://api.zipaddress.net/"
    response = RestClient.get "#{base_url}?query=#{URI.encode(address)}"
    data = JSON.parse(response.body)
    data['code'] == 200 ? data['data']['fullAddress'] : nil
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Failed to retrieve postal code: #{e.response}"
    nil
  end
end
