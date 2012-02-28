require 'yaml'

def load_config(f)
  config = nil
  if File.exists?(f)
    config = YAML.load_file(f)
  end
  config
end

f = File.dirname(__FILE__) + '/config.yml'
@config = load_config(f)
@config = load_config(File.expand_path(File.join("~", "Dropbox", "configs", "boomi", "config.yml"))) unless @config
@config = {} unless @config

@config["iron"] ||= {}
@config["iron"]["token"] ||= ENV['IRON_TOKEN'] || ENV['IRON_WORKER_TOKEN']
@config["iron"]["project_id"] ||= ENV['IRON_PROJECT_ID'] || ENV['IRON_WORKER_PROJECT_ID']

@config["mongo"] ||= {}
@config["mongo"]["uri"] ||= ENV['MONGODB_URI']
@config["mongo"]["database"] ||= ENV['MONGODB_DATABASE']
