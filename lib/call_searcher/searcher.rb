# frozen_string_literal: true

module CallSearcher
  class Searcher
    def initialize(&blk)
      @condition = blk || ->(_) { true }
    end

    def search(ast: nil, src: nil)
      if ast.nil? && src.nil?
        raise ArgumentError, "Either ast or src is required"
      end

      if ast.nil?
        ast = RubyVM::AbstractSyntaxTree.parse(src)
      end

      filter(ast)
    end

    private

    def filter(node)
      ret = node.children.grep(RubyVM::AbstractSyntaxTree::Node).flat_map do |child|
        filter(child)
      end

      case node.type
      when :CALL, :QCALL, :OPCALL, :FCALL, :VCALL
        method_call = CallSearcher::MethodCall.new(node: node)
        if @condition.call(method_call)
          ret << method_call
        end
      else
        nil
      end

      ret
    end
  end
end
