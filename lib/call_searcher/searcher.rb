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
      nodes = []
      nodes << ast if match?(ast)
      search_children(ast.children, nodes)
      nodes
    end

    private

    def search_children(children, nodes)
      return unless children
      children.each do |child|
        next unless child.is_a?(RubyVM::AST::Node)

        nodes << child if match?(child)
        search_children(child.children, nodes)
      end
    end

    def match?(node)
      CALL_NODES.include?(node.type)
    end
  end
end
