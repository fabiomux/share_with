# frozen_string_literal: true

module ShareWith
  #
  # Entry point class that handles the service collection.
  #
  class Collection
    attr_reader :services

    def initialize(args = {})
      @paths = args[:paths] || []
      @extend_with = args[:extend_with] || []
      @services = {}
      return unless args[:services]

      args[:services].each do |s|
        @services[s.to_sym] = Service.new(s, { paths: @paths, extend_with: @extend_with })
      end
    end

    def inspect(service, var_path)
      @services[service.to_sym].inspect(var_path)
    end

    def get_param(service, key)
      @services[service.to_sym].get_param(key) if @services.key?(service.to_sym)
    end

    def set_param(service, key, value)
      @services[service.to_sym].set_param(key, value) if @services.key?(service.to_sym)
    end

    def set_param_to(services, key, value)
      services.each do |s|
        set_param s, key, value if @services.key? s.to_sym
      end
    end

    def set_param_to_all(key, value)
      @services.each_key do |s|
        set_param(s, key, value)
      end
    end

    def set_conditional_param(key, value)
      if key.include? ":"
        services, param = key.split(":")
        set_param_to(services.split(","), param, value)
      else
        set_param_to_all(key, value)
      end
    end

    def get_value(service, key)
      @services[service.to_sym].get_value(key)
    end

    def set_value(service, key, value)
      @services[service.to_sym].set_value(key, value)
    end

    def set_value_to(services, key, value)
      services.each do |s|
        set_value s, key, value if @services.key? s.to_sym
      end
    end

    def set_value_to_all(key, value)
      @services.each_key do |s|
        set_value(s, key, value)
      end
    end

    def create_or_reset(service)
      if @services.include? service.to_sym
        @services[service.to_sym].reset!
      else
        @services[service.to_sym] = Service.new(service, { paths: @paths, extend_with: @extend_with })
      end
    end

    def reset_all!
      @services.each do |_k, s|
        s.reset!
      end
    end

    def render(service, template)
      @services[service.to_sym].render(template)
    end

    def render_all(template)
      res = {}
      @services.each do |k, _v|
        res[k] = render(k, template)
      end

      res
    end
  end
end
