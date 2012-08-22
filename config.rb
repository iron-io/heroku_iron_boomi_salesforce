require 'yaml'
require 'uber_config'
require 'iron_worker_ng'

@config = UberConfig.load
UberConfig.symbolize_keys!(@config)

@config = {} unless @config
@config[:iron] ||= {}
#@config[:iron][:token] ||= ENV['IRON_TOKEN'] || ENV['IRON_WORKER_TOKEN']
#@config[:iron][:project_id] ||= ENV['IRON_PROJECT_ID'] || ENV['IRON_WORKER_PROJECT_ID']

ENV['IRON_TOKEN'] ||= @config[:iron][:token]
ENV['IRON_PROJECT_ID'] ||= @config[:iron][:project_id]

module SingletonConfig
  def self.config=(c)
    @config = c
  end
  def self.config
    @config
  end
end

SingletonConfig.config = @config
