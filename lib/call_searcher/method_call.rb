# frozen_string_literal: true

module CallSearcher
  class MethodCall
    attr_reader :node

    def initialize(node:, context:)
      @node = node
      @context = context
    end

    def type
      @type ||= node.type
    end

    def receiver
      case type
      when :FCALL, :VCALL
        nil
      else
        node.children[0]
      end
    end

    def mid
      case type
      when :FCALL, :VCALL
        node.children[0]
      else
        node.children[1]
      end
    end

    def location
      "#{@context.path}:#{@node.first_lineno}"
    end
  end
end
