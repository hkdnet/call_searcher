# frozen_string_literal: true

module CallSearcher
  class MethodCall
    attr_reader :type, :mid, :receiver
    attr_reader :arg_node, :recv_node

    def initialize(node)
      @type = node.type
      case @type
      when "NODE_FCALL"
        @mid, @arg_node = node.children
      when "NODE_CALL", "NODE_QCALL"
        @recv_node, @mid, @arg_node = node.children
      else
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

        if e.type == 'NODE_LIT'
          arr << e.children.first
        else
          arr << e
        end
      end
    end
  end
end
