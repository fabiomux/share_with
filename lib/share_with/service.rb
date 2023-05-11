# frozen_string_literal: true

require "yaml"

module ShareWith
  #
  # The single service classification.
  #
  class Service
    include Placeholders
    include LinkFactory

    def initialize(service_name, args = {})
      @name = service_name
      @paths = args[:paths] || []
      @extend_with = args[:extend_with] || []
      @paths = (@paths << File.join(File.dirname(__FILE__), "services"))
      @data = load(@name)

      @data = inherit_from(info[:inherit_from]) if info.key?(:inherit_from)

      @extend_with = (info[:extend_with] || []).concat(@extend_with) if info.key?(:extend_with)

      # if info.key?(:extend_with)
      if @extend_with
        # extend_with_layers(info[:extend_with])
        extend_with_layers(@extend_with)
      else
        # Create the params when no more extensions are requested.
        create_params
      end
    end

    def param?(key)
      params.key?(key.to_sym)
    end

    def get_param(key)
      return params[key.to_sym].value if param?(key)
    end

    def set_param(key, value)
      params[key.to_sym].value = value if param?(key)
    end

    def set_conditional_param(key, value)
      if key.include? ":"
        services, param = key.split(":")
        set_param(param, value) if services.split(",").include?(@name)
      else
        set_param(key, value)
      end
    end

    def get_value(key)
      raise InvalidParam, "params.#{key}" unless param?(key.to_sym)

      params[key.to_sym].value
    end

    def set_value(key, value)
      raise InvalidParam, "params.#{key}" unless param?(key.to_sym)

      params[key.to_sym].value = value
    end

    def reset!
      params.each { |_k, v| v.reset! }
      includes.each { |_k, v| v.delete :cache }
      # extend_with_layers(@extend_with)
    end

    def add_layer(layer)
      @extend_with << layer
      extend_with_layers(layer)
    end

    private

    def info
      @data[:info]
    end

    def templates
      @data[:templates]
    end

    def params
      @data[:params]
    end

    def includes
      @data[:includes]
    end

    def create_params
      params.each do |k, v|
        @data[:params][k] = ServiceDataFactory.create(v) if [String, Hash].include? v.class
      end
    end

    def extend_with_layers(layers)
      layers = [layers] if layers.instance_of? String
      layers.each do |name|
        name = name.split(".")
        layer = load("_#{name[0]}")[name[1]]

        raise InvalidLayer, [name[0], name[1]] if layer.nil?

        @data[:params].merge!(layer[:params]) if layer.key? :params
        @data[:includes].merge!(layer[:includes]) if layer.key? :includes
        @data[:templates].merge!(layer[:templates]) if layer.key? :templates
      end

      create_params
    end

    def inherit_from(service_name)
      data = load(service_name)
      data[:info] = {}.merge! @data[:info]
      data[:params].merge!(params) unless params.empty?
      data[:includes].merge!(includes) unless includes.empty?
      data[:templates].merge!(templates) unless templates.empty?

      data
    end

    def merge_template!(service_name, tpl_name)
      source = load(service_name)
      @data[:includes].merge! source[:includes]
      @data[:templates][tpl_name.to_sym].merge! source[:templates][tpl_name.to_sym]
      # to don't merge again and again
      @data[:templates][tpl_name.to_sym].delete :inherit_from
    end

    def load(service_name)
      @paths.each do |d|
        fname = File.join(File.expand_path(d), "#{service_name}.yaml")
        next unless File.exist? fname

        res = YAML.load_file(fname)
        res[:includes] ||= {}
        res[:params] ||= {}
        res[:templates] ||= {}
        return res
      end
      raise InvalidService, service_name
    end
  end
end
