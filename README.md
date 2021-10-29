# Capistrano::Dotenv::Tasks

Show, set and delete env vars in your `.env` remote file with Capistrano 3.

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'dotenv'  # if you haven't added it, already
gem 'capistrano-dotenv-tasks', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-dotenv-tasks

## Usage

Require it in your Capfile:

```ruby
require 'capistrano/dotenv/tasks'
```

Make the `.env` file
[a file that is shared between releases](http://capistranorb.com/documentation/getting-started/structure/)
by adding one of the following lines to your `config/deploy.rb` script:

```ruby
append :linked_files, '.env'  # for capistrano >= 3.5
set :linked_files, fetch(:linked_file, []).push('.env')  # for capistrano < 3.5
```

Then, access the capistrano rake tasks to edit your remote `.env` file from
the `cap` command.


### Show your config

```
$ cap production config:show
```

### Set (create or update) a variable

```
$ cap production config:set VARNAME=value
```

### Remove a variable

```
$ cap production config:remove[VARNAME]
```

Or multiple at once:

```
$ cap production config:remove[VARNAME1,VARNAME2]
```

## Configuration

Set the env file for a given environment by adding the following line to your `config/deploy/staging.rb` script:
```ruby
set :capistrano_dotenv_file, -> { '.env.staging' }
```


## Contributing

1. Fork it ( https://github.com/glyph-fr/capistrano-dotenv-tasks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT
