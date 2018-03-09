require 'stringio'

module Capistrano
  module Dotenv
    class Config
      VARIABLE_PATTERN = /^(\w+)=(.+)$/i

      attr_reader :contents, :variables

      def initialize(contents = ''.freeze)
        @contents = contents.to_s
        @variables = {}
        add(*@contents.lines)
      end

      def set(key, value)
        variables[key] = value
      end

      def compile
        Hash[variables.sort].map do |key, value|
          %(#{ key }=#{ value })
        end.join("\n") << "\n"
      end
      alias_method :to_s, :compile

      def add(*args)
        args.each do |string|
          if (variable = extract_variable_from(string.strip))
            key, value = variable
            set(key, value)
          end
        end
      end

      def remove(*args)
        args.each do |key|
          variables.delete(key)
        end
      end

      def to_io
        StringIO.new(compile)
      end

      private

      def extract_variable_from(string)
        if (matches = string.match(VARIABLE_PATTERN))
          key = matches[1]
          value = matches[2]

          if key && value
            [key, value]
          end
        end
      end
    end
  end
end
