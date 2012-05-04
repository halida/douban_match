require './crawler'
require 'pp'

$db = DB.new "localhost"

def crawl_some_data
  c = Crawler.new
  
  result = c.crawl_user 'linjunhalida'
  
  # crawl for 6 level
end

def count_recommender_data
  # todo
end

def find_matched_user user
  # todo
end

crawl_some_data
count_recommender_data
find_matched_user "linjunhalida"

