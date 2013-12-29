require 'net/http'
require 'uri'
require 'base64'

class Images::Upload
  def upload(image_data)
    # image_data = File.open('/Users/merlyn/fun/gostly/go-board.png', 'rb') do |f|
    #   Base64.encode64(f.read)
    # end

    uri = URI.parse("https://api.imgur.com/3/image.json")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"image" => image_data})
    request["Authorization"] = "Client-ID #{ENV['IMGUR_CLIENT_ID']}"

    response = http.request(request)

    puts response.class.name
    puts response.body
    puts JSON.parse(response.body).inspect
    JSON.parse(response.body)['data']['link']
  end
end
