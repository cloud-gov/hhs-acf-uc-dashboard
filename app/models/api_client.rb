class ApiClient
  attr_reader :base_url

  def initialize(base_url=nil)
    @base_url = base_url || ENV['API_URL']
  end

  def daily_statistics
    get_json("daily_statistics/count")
  end

  private

  def get_json(path)
    response = RestClient.get("#{base_url}/#{path}", headers)
    JSON.parse(response.body)
  end

  def headers
    {Authorization: "Token #{token}"}
  end

  def token
    JWT.encode({:role => 'user role', :exp => Time.now.to_i + 86400}, hmac_secret, "HS512")
  end

  def hmac_secret
    ENV["AUTH_HMAC_SECRET"]
  end
end
