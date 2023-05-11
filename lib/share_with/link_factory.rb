# frozen_string_literal: true

module ShareWith
  #
  # Methods to create the HTML code to represent the sharing links.
  #
  module LinkFactory
    def render(tpl_name)
      raise InvalidTemplate, tpl_name unless templates.key? tpl_name.to_sym

      template = templates[tpl_name.to_sym]

      merge_template!(template[:inherit_from], tpl_name) if template.key? :inherit_from

      includes&.each do |k, _v|
        i = includes[k]
        i[:cache] = traverse_node(i[:content]) unless i.key? :cache
      end

      traverse_node(template[:content])
    end

    private

    def traverse_node(node)
      res = []

      if node.instance_of? Hash
        node.each do |k, v|
          attr = ""
          attr = expand_attributes(v) if v.key? :attr
          res << (v.key?(:content) ? "<#{k} #{attr}>#{traverse_node(v[:content])}</#{k}>" : "<#{k} #{attr} />")
        end
      elsif node.instance_of? String
        res << expand_all(node)
      end

      res.join
    end

    def expand_attributes(value)
      value[:attr].keys.map do |k|
        if value[:attr][k].nil?
          str = k
        else
          str = expand_all(value[:attr][k])
          str = "#{k}=\"#{str}\"" unless str.empty?
        end
        str
      end.delete_if(&:empty?).join " "
    end
  end
end
