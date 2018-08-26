RSpec.describe CallSearcher::Searcher do
  let(:searcher) { CallSearcher::Searcher.new }

  let(:ast) do
    RubyVM::AST.parse(text)
  end

  context 'no call' do
    let(:text) do
      <<~RUBY
def foo
end
      RUBY
    end

    it do
      expect(searcher.search(ast)).to be_empty
    end
  end

  context 'call :foo' do
    let(:text) do
      <<~RUBY
def foo
end
foo
      RUBY
    end

    it do
      result = searcher.search(ast)
      expect(result.size).to eq 1
    end
  end
end
