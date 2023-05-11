# frozen_string_literal: true

module ShareWith
  #
  # It provides the methods to replace the placeholders
  #   with the correct data pointed.
  #
  module Placeholders
    def expand_all(str)
      loop do
        # Conditional params, if null remove the string
        str = str.gsub(/\[([^ \]]+)\]/) do |x|
          res = expand_all(x.delete("[]"))
          @empty ? "" : res
        end

        str = str.gsub(%r{<([^ />]+)>}) do |x|
          res = inspect(x.delete("<>"))
          @empty = res.to_s.empty?
          res.nil? ? x : res
        end

        break unless str =~ %r{<[^ />]+>}
      end

      str
    end

    def inspect(var_path)
      context, var_name, var_select, attr_key = var_path.split(".")
      var_select ||= :value
      # puts @data,var_name,var_select if context.to_sym == :https
      res = send(context.to_sym)

      raise InvalidContext, context if res.nil?

      return res.send(var_name.to_sym) if %i[keys values].include? var_name.to_sym

      raise InvalidParam, [context, var_name].join(".") unless res.key? var_name.to_sym

      res = res[var_name.to_sym]
      case context.to_sym
      when :params
        value_selection(res, attr_key, var_select)
      when :includes
        res[:cache]
      else
        res
      end
    end

    private

    def value_selection(val, attr_key, var_select)
      case var_select.to_s.to_sym
      when :key
        val.key
      when :attr
        val.attr(attr_key)
      else
        val.value
      end
    end
  end
end
