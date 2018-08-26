# frozen_string_literal: true

module CallSearcher
  class Searcher
    CALL_NODES = %w[
      NODE_CALL
      NODE_FCALL
      NODE_OPCALL
      NODE_QCALL
      NODE_VCALL
    ].freeze
    private_constant :CALL_NODES

    def search(ast)
      ret = []
      ret << ast if match?(ast)
      search_children(ast.children, ret)
      ret
    end

    private

    def search_children(children, ret)
      return unless children
      children.each do |child|
        next unless child.is_a?(RubyVM::AST::Node)

        ret << child if match?(child)
        search_children(child.children, ret)
      end
    end

    def match?(node)
      CALL_NODES.include?(node.type)
    end
  end
end
