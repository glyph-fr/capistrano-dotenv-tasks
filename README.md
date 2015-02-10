# Capistrano::Dotenv::Tasks

Show, set and delete env vars in your `.env` remote file with Capistrano 3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-dotenv-tasks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-dotenv-tasks

## Usage

Require it in your Capfile :

```
require 'capistrano/dotenv/tasks'
```

Then use it from the `cap` command.


### Show your config

```
cap production config:show
```

### Create / Update a variable

```
cap production config:set VARNAME=value
```

### Delete a variable

```
cap production config:remove key=VARNAME
```

## Contributing

1. Fork it ( https://github.com/glyph-fr/capistrano-dotenv-tasks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

MIT
