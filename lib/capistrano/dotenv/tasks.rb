require "capistrano/dotenv/version"
require "capistrano/dotenv/config"

namespace :config do
  desc "fetch existing environments variables from .env config file"
  task :show do
    on roles(:app) do
      puts capture("cat #{ shared_path }/.env")
    end
  end

  desc "Set an environment variable in .env config file"
  task :set do
    on roles(:app) do
      config = Capistrano::Dotenv::Config.new(capture("cat #{ shared_path }/.env"))
      config.add(*ARGV[2..-1])
      upload!(StringIO.new(config.compile), "#{ shared_path }/.env")
    end
  end

  desc "Removes an environment variable from the .env config file"
  task :remove do |t, args|
    unless ENV['key']
      raise "You need to set `key=KEY_TO_BE_REMOVED` to remove a key"
    end

    on roles(:app) do
      config = Capistrano::Dotenv::Config.new(capture("cat #{ shared_path }/.env"))
      config.remove(ENV['key'])
      upload!(StringIO.new(config.compile), "#{ shared_path }/.env")
    end
  end
end
