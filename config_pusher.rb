require 'iron_cache'
require 'uber_config'
require 'yaml'
require 'open-uri'

class ConfigPusher
  def push

    @config = UberConfig.load
    puts @config.to_yaml

    c = IronCache::Client.new
    cache = c.cache("configs")
    item = cache.put(@config['app_name'], @config.to_yaml)
    p item

    url = cache.url(@config['app_name'])
    puts "url: #{url}"
    url_with_token = url + "?oauth=#{c.token}"
    puts url_with_token


  end
end
