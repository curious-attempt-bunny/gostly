require 'net/http'
require 'uri'
require 'base64'

class Images::Upload
  def upload(url)
    uri = URI.parse("https://api.imgur.com/3/image.json")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"image" => url})
    request["Authorization"] = "Client-ID #{ENV['IMGUR_CLIENT_ID']}"

    response = http.request(request)

    Rails.logger.error JSON.parse(response.body).inspect
    JSON.parse(response.body)['data']['link']
  end
end
