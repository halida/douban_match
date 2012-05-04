require 'mongo'

class DB
  def initialize server, name
    @db = Mongo::Connection.new(server).db(name)
    # @db.authenticate('adminuser', 'admin-crawler-unicorn')
  end

  def db
    @db
  end

  def [](name)
    @db[name]
  end
end

module Mongo
  class Collection
    def update_only by, sets
      self.update(by, {"$set" => sets})
    end  

    def find_or_create id, data={}
      result = self.find_one id: id
      return result if result
      self.insert(data.merge(id: id).skip_dollar)
      data
    end

    def update_or_create by, sets={}
      result = self.find_or_create by
      self.update_only by, sets
    end

  end
end

module BSON
  class OrderedHash
    def [](name)
      name = name.to_s if name.class == Symbol
      super name
    end

    def skip_dollar
      iter_tree_hash_key(self){|key, value| key == '$t' ? [value, false] : [key, true]}
    end

    def iter_tree_hash_key hash
      pairs = hash.map do |k, v|
        k = k[1..-1] if k[0] == '$'
        v = v.map{|i| i.instance_of?(Hash) ? iter_tree_hash_key(i) : i} if v.instance_of? Array
        [k, v]
      end        
      Hash[pairs]
    end
  end
end

class Hash
  def sym2str
    self.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
  end

  def str2sym
    self.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end

