require 'yaml'
require 'uber_config'
require 'iron_worker_ng'
require 'iron_cache'
require 'open-uri'

#begin
#  @config = UberConfig.load
#  UberConfig.symbolize_keys!(@config)
#rescue => ex
#  puts "Couldn't load UberConfig: #{ex.message}"
#end

@config = {} unless @config
@config[:iron] ||= {}
#@config[:iron][:token] ||= ENV['IRON_TOKEN'] || ENV['IRON_WORKER_TOKEN']
#@config[:iron][:project_id] ||= ENV['IRON_PROJECT_ID'] || ENV['IRON_WORKER_PROJECT_ID']

ENV['IRON_TOKEN'] ||= @config[:iron][:token]
ENV['IRON_PROJECT_ID'] ||= @config[:iron][:project_id]

if ENV['CONFIG_CACHE_KEY']
  puts "Getting config from #{ENV['CONFIG_CACHE_KEY']}"
  config_from_cache = open(ENV['CONFIG_CACHE_KEY']).read
  config_from_cache = JSON.parse(config_from_cache)
  config_from_cache = YAML.load(config_from_cache['value'])
  p config_from_cache

  @config.merge!(config_from_cache)
end

p @config

module SingletonConfig
  def self.config=(c)
    @config = c
  end

  def self.config
    @config
  end
end

SingletonConfig.config = @config
