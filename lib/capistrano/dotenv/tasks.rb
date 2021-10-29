require "capistrano/dotenv/version"
require "capistrano/dotenv/config"

require 'shellwords'

set :capistrano_dotenv_role, -> { :app }
set :capistrano_dotenv_file do
  default_file = '.env'
  prompt = 'Enter .env.ENVIRONMENT or nothing to use the default'
  ask(:answer, default_file, prompt: prompt)
end
set :capistrano_dotenv_file, -> { '.env' }
set :capistrano_dotenv_path, -> { shared_path.join(fetch(:capistrano_dotenv_file)) }
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
    dotenv_path = fetch(:capistrano_dotenv_path_escaped)

    on roles(fetch(:capistrano_dotenv_role)) do
      contents = capture(:cat, dotenv_path) if test fetch(:capistrano_dotenv_path_exists)
      config = Capistrano::Dotenv::Config.new(contents)

      if ENV['key']
        $stderr.puts "DEPRECATION WARNING: Using `key=KEY_TO_BE_REMOVED` is deprecated, just pass the keys as arguments to the task; `config:remove[KEY_A,KEY_B]`"
        config.remove(ENV['key'])
      else
        config.remove(*args.extras)
      end
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
