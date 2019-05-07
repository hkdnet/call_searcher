RSpec.describe CallSearcher::Searcher do
  subject { searcher.search(src: text) }
  let(:searcher) { CallSearcher::Searcher.new }

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
        expect(subject.first.type).to eq :VCALL
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
        expect(subject.first.type).to eq :FCALL
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
        expect(subject.first.type).to eq :QCALL
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
        expect(subject.first.type).to eq :CALL
      end
    end

    context 'OPCALL' do
      let(:text) do
        '1 + 2'
      end

      it do
        expect(subject.size).to eq 1
        expect(subject.first.type).to eq :OPCALL
      end
    end
  end
end
