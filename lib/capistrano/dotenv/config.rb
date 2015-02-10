module Capistrano
  module Dotenv
    class Config
      VARIABLE_PATTERN = /^(\w+)=(.+)$/i

      attr_accessor :contents

      def initialize(contents)
        self.contents = contents
        add(*contents.lines)
      end

      def set(key, value)
        variables[key] = value
      end

      def variables
        @variables ||= {}
      end

      def compile
        variables.map do |key, value|
          %(#{ key }="#{ value }")
        end.join("\n")
      end

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

      private

      def extract_variable_from(string)
        if (matches = string.match(VARIABLE_PATTERN))
          key = matches[1]
          value = matches[2]

          return unless key && value

          value.gsub!(/^['"]|['"]$/, '')

          [key, value]
        end
      end
    end
  end
end
