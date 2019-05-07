# frozen_string_literal: true

module CallSearcher
  class Searcher
    def initialize(&blk)
      @condition = blk || ->(*) { true }
    end

    def search_dir(root_dir: '.', path:, github: nil)
      path = File.expand_path(path, root_dir)
      context = CallSearcher::Context.new(github: github)
      Dir.glob(File.join(path, "**", "*.rb")).reduce([]) do |arr, f|
        if File.file?(f)
          arr + search(file: f, context: context)
        end
      end
    end

    def search(file:, context: nil)
      context = context&.dup || CallSearcher::Context.new
      context.path = file

      ast = RubyVM::AbstractSyntaxTree.parse_file(file)

      filter(ast, context)
    end

    private

    def filter(node, context)
      ret = node.children.grep(RubyVM::AbstractSyntaxTree::Node).flat_map do |child|
        filter(child, context)
      end

      case node.type
      when :CALL, :QCALL, :OPCALL, :FCALL, :VCALL
        method_call = CallSearcher::MethodCall.new(node: node, context: context)
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
