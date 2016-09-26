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
    response = RestClient.get("#{base_url}/#{path}")
    JSON.parse(response.body)
  end
end
