RSpec.describe CallSearcher::Searcher do
  subject { searcher.search(ast) }
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

    it { is_expected.to be_empty }
  end

  context 'call :foo' do
    context 'VCALL' do
      let(:text) do
        <<~RUBY
def foo
end
foo
        RUBY
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq "NODE_VCALL"
      end
    end

    context 'FCALL' do
      let(:text) do
        <<~RUBY
def foo
end
foo()
        RUBY
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq "NODE_FCALL"
      end
    end

    context 'QCALL' do
      let(:text) do
        <<~RUBY
def foo
end
self&.foo
        RUBY
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq "NODE_QCALL"
      end
    end

    context 'CALL' do
      let(:text) do
        <<~RUBY
def foo
end
self.foo
        RUBY
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq "NODE_CALL"
      end
    end

    context 'OPCALL' do
      let(:text) do
        '1 + 2'
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq "NODE_OPCALL"
      end
    end
  end
end
