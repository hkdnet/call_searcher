# frozen_string_literal: true

module CallSearcher
  class MethodCall
    attr_reader :type, :mid, :receiver
    attr_reader :arg_node, :recv_node

    def initialize(node)
      @type = node.type
      case @type
      when "NODE_FCALL", "NODE_VCALL"
        @mid, @arg_node = node.children
      when "NODE_CALL", "NODE_QCALL", "NODE_OPCALL"
        @recv_node, @mid, @arg_node = node.children
      else
        raise "unknown type"
      end
    end

    def args
      @args ||= build_args
    end

    private

    def build_args
      return [] if @arg_node.nil?

      @arg_node.children.each_with_object([]) do |e, arr|
        break arr if e.nil? # end argument

        case e.type
        when 'NODE_LIT'
          arr << e.children.first
        when 'NODE_STR'
          arr << e.children.first
        else
          arr << e
        end
      end
    end
  end
end
