# frozen_string_literal: true

module CallSearcher
  class Searcher
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
        if match?(node)
          ret << CallSearcher::MethodCall.new(node: node)
        end
      else
        nil
      end

      ret
    end

    def match?(node)
      true
    end
  end
end
