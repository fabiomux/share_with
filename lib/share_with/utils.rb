# frozen_string_literal: true

require "erb"
require "loofah"

module ShareWith
  #
  # Monkey patching of the String class.
  #
  class ::String
    def to_escaped_html
      ERB::Util.html_escape(self)
    end

    def to_encoded_url_param
      ERB::Util.url_encode(self)
    end

    def to_plain_text
      Loofah.fragment(self).text
    end
  end

  #
  # Monkey patching of the Array class.
  #
  class ::Array
    def to_text_list(separator = ",")
      map do |x|
        x.to_s.to_plain_text.gsub(/[^a-z]/, "")
      end.join(separator)
    end
  end

  #
  # Invalid service error.
  #
  class InvalidService < StandardError
    def initialize(name)
      super "Invalid service: #{name}"
    end
  end

  #
  # Invalid layer error.
  #
  class InvalidLayer < StandardError
    def initialize(args)
      super "Invalid layer: #{args[1]} in #{args[0]} service"
    end
  end

  #
  # Invalid data type error.
  #
  class InvalidDataType < StandardError
    def initialize(type)
      super "Invalid data type: #{type}"
    end
  end

  #
  # Invalid value error.
  #
  class InvalidValue < StandardError
    def initialize(args)
      super "Invalid value: #{args[0]}, the allowed values are: #{args[1].join(", ")}"
    end
  end

  #
  # Invalid template error,
  #
  class InvalidTemplate < StandardError
    def initialize(template)
      super "Invalid template: #{template}"
    end
  end

  #
  # Invalid context error.
  #
  class InvalidContext < StandardError
    def initialize(context)
      super "Invalid context: #{context}"
    end
  end

  #
  # Invalid param error.
  #
  class InvalidParam < StandardError
    def initialize(var_name)
      super "Invalid param: #{var_name}"
    end
  end
end
