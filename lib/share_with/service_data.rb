# frozen_string_literal: true

module ShareWith
  #
  # Define the data type allowed.
  #
  module ServiceDataType
    #
    # This works as an abstract class to inherit.
    #
    class BasicDataType
      attr_reader :label
      attr_writer :value

      def initialize(data)
        @data = data
        @default = data[:default]
        @value = @default
      end

      def value(encoding = nil)
        res = @value || @default || ""
        res = res.send(encoding.to_sym) unless encoding.nil?

        res
      end

      def attr(attr_value)
        @data[:attr][attr_value]
      end

      def reset!
        self.value = @default
      end
    end

    #
    # Define a boolean type.
    #
    class Boolean < BasicDataType
      def value=(val)
        @value = [true, "true", 1, "1"].include? val
      end
    end

    #
    # Define an integer type.
    #
    class Integer < BasicDataType
      def value=(val)
        @value = val.to_i
      end
    end

    #
    # Define a list of string type.
    #
    class StringList < BasicDataType
      def initialize(data)
        super
        @value = []
        @separator = data[:separator] || ","
        reset!
      end

      def value
        @value.to_text_list @separator
      end

      def value=(val)
        val = val.split(@separator) if val.instance_of?(String)
        val = "" if val.nil?

        if val.empty?
          clear
        else
          @value.concat val
        end
      end

      def delete(val)
        @value.delete val
      end

      def clear
        @value.clear
      end

      def reset!
        clear
        @value = @default.instance_of?(String) ? @default.split(@separator).map(&:trim) : @default.clone
      end
    end

    #
    # Define a select value type.
    #
    class Select < BasicDataType
      # aliasing the ancestor method to meet the new meanings
      alias key value

      def value
        @data[:options][key].instance_of?(String) ? @data[:options][key] : @data[:options][key][:value]
      end

      def value=(val)
        raise InvalidValue, [val, @data[:options].keys] unless @data[:options].key? val

        @value = val
      end

      def attr(attr_value)
        @data[:options][key][:attr][attr_value]
      end
    end

    #
    # Define an encoded text type.
    #
    class EncodedText < BasicDataType
      def value
        super :to_escaped_html
      end
    end

    #
    # Define a plain text type.
    #
    class PlainText < BasicDataType
      def value
        super :to_plain_text
      end
    end

    #
    # Define an encoded URL type.
    #
    class EncodedUrlParam < BasicDataType
      def value
        super :to_encoded_url_param
      end
    end

    #
    # Define a reference type.
    #
    class Reference < BasicDataType
      def initialize(data)
        super type: :reference, default: data
      end

      def value=(val)
        # No value can be assigned being only a reference
      end

      def value
        "<#{@value.gsub(/[^a-z._]+/, "")}>"
      end
    end
  end

  #
  # Convert an argument to a ServiceDataType object.
  #
  class ServiceDataFactory
    def self.create(args)
      if args.instance_of? String
        res = ServiceDataType::Reference.new(args)
      else
        type = args[:type].to_s.split("_").map(&:capitalize).join
        raise InvalidDataType, type unless ShareWith::ServiceDataType.constants.include? type.to_sym

        res = Object.const_get("ShareWith::ServiceDataType::#{type}").new(args)
      end

      res
    end
  end
end
