require "capistrano/dotenv/version"
require "capistrano/dotenv/config"

set :capistrano_dotenv_path, -> { shared_path.join('.env') } 

namespace :config do
  desc "fetch existing environments variables from .env config file"
  task :show do
    on roles(:app) do
      puts capture(:cat, fetch(:capistrano_dotenv_path))
    end
  end

  desc "Set an environment variable in .env config file"
  task :set do
    dotenv_path = fetch(:capistrano_dotenv_path)
    
    on roles(:app) do
      config = Capistrano::Dotenv::Config.new(capture(:cat, dotenv_path))
      config.add(*ARGV[2..-1])
      upload!(StringIO.new(config.compile), dotenv_path)
    end
  end

  desc "Removes an environment variable from the .env config file"
  task :remove do |t, args|
    unless ENV['key']
      raise "You need to set `key=KEY_TO_BE_REMOVED` to remove a key"
    end

    dotenv_path = fetch(:capistrano_dotenv_path)

    on roles(:app) do
      config = Capistrano::Dotenv::Config.new(capture(:cat, dotenv_path))
      config.remove(ENV['key'])
      upload!(StringIO.new(config.compile), dotenv_path)
    end
  end
end
