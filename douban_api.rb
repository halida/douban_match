require 'nestful'
require 'json'

class DoubanAPI
  def initialize
    @apikey = '0f89b8bc396423112e9d2a34ac2c6933'
    @secret = '4e0d52e13eb41484'
    @host = 'http://api.douban.com'

    @per_page = 50
  end

  def get_collection(type, user_id)
    url = "/people/#{user_id}/collection"
    result = get_data url, cat: type
  end

  def get_contacts user_id
    url = "/people/#{user_id}/contacts"
    result = get_data url
  end

  def get_datas url, opt
    # todo
    data = []
    # opt["max-results"] = @per_page
    # start_index = 0
    # do
    #   opt["start-index"] = start_index
    #   result = get_data url, opt
    #   start_index += @per_page
    # while (result['opensearch:totalResults']['$t'].to_i <= start_index)
    # data
  end

  def get_data url, opt={}
    opt.merge! alt: :json, apikey: @apikey
    Nestful.json_get(@host + url, opt)
  end

end

