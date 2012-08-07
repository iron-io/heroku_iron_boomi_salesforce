require 'yaml'
require 'uber_config'

@config = UberConfig.load
UberConfig.symbolize_keys!(@config)

@config = {} unless @config
@config[:iron] ||= {}
#@config[:iron][:token] ||= ENV['IRON_TOKEN'] || ENV['IRON_WORKER_TOKEN']
#@config[:iron][:project_id] ||= ENV['IRON_PROJECT_ID'] || ENV['IRON_WORKER_PROJECT_ID']

ENV['IRON_WORKER_TOKEN'] ||= @config[:iron][:token]
ENV['IRON_WORKER_PROJECT_ID'] ||= @config[:iron][:project_id]


