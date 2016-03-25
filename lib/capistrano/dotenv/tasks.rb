require "capistrano/dotenv/version"
require "capistrano/dotenv/config"

require 'shellwords'

set :capistrano_dotenv_role, -> { :app }
set :capistrano_dotenv_path, -> { shared_path.join('.env') }
set :capistrano_dotenv_path_escaped, -> {fetch(:capistrano_dotenv_path).to_s.shellescape }
set :capistrano_dotenv_path_exists, -> { "[ -f #{fetch(:capistrano_dotenv_path_escaped)} ]" }

namespace :config do
  desc "fetch existing environments variables from .env config file"
  task :show do
    dotenv_path = fetch(:capistrano_dotenv_path_escaped)

    on roles(fetch(:capistrano_dotenv_role)) do
      if test fetch(:capistrano_dotenv_path_exists)
        capture(:cat, dotenv_path).each_line do |line|
          info line
        end
      end
    end
  end

  desc "Set an environment variable in .env config file"
  task :set do
    dotenv_path = fetch(:capistrano_dotenv_path_escaped)

    on roles(fetch(:capistrano_dotenv_role)) do
      contents = capture(:cat, dotenv_path) if test fetch(:capistrano_dotenv_path_exists)
      config = Capistrano::Dotenv::Config.new(contents)

      config.add(*ARGV[2..-1])

      upload!(config.to_io, dotenv_path)
    end
  end

  desc "Removes an environment variable from the .env config file"
  task :remove do |t, args|
    unless ENV['key']
      raise "You need to set `key=KEY_TO_BE_REMOVED` to remove a key"
    end

    dotenv_path = fetch(:capistrano_dotenv_path_escaped)

    on roles(fetch(:capistrano_dotenv_role)) do
      contents = capture(:cat, dotenv_path) if test fetch(:capistrano_dotenv_path_exists)
      config = Capistrano::Dotenv::Config.new(contents)

      config.remove(ENV['key'])
      upload!(config.to_io, dotenv_path)
    end
  end
end

namespace :dotenv do
  desc 'create the .env in shared directory'
  task :touch do
    on release_roles :all do # same as deploy:check:linked_files
      execute :touch, fetch(:capistrano_dotenv_path_escaped)
    end
  end
end
