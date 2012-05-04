require './douban_api'
require './db'

class Crawler
  def initialize
    @douban = DoubanAPI.new
    @db = DB.new 'localhost', 'douban'
  end

  def crawl_user user_id
    crawl_user_interests user_id
    crawl_user_contacts user_id
  end

  def crawl_user_contacts user_id
    result = @douban.get_contacts user_id
    ids = result['entry'].map do |entry|
      id = entry['db:uid']['$t'].to_i
      @db[:users].find_or_create id, entry
      id
    end
    @db[:contacts].find_or_create user_id, {user_id: user_id, ids: ids}
  end

  def crawl_user_interests user_id
    # get user interests
    result = @douban.get_collection :book, user_id

    # save items
    ids = result['entry'].map do |entry|
      id = entry['id']['$t'].match(/(\d+)$/)[0].to_i
      @db[:books].find_or_create id, entry
      id
    end

    @db[:book_collections].find_or_create user_id, {user_id: user_id, ids: ids}
  end
end
