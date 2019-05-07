require 'tempfile'

RSpec.describe CallSearcher::Searcher do
  describe '#search' do
    subject { searcher.search(file: file_path) }

    let(:searcher) { CallSearcher::Searcher.new }
    let(:file_path) { tmpfile.path }
    let(:tmpfile) do
      Tempfile.new.tap do |f|
        f.write(text)
        f.flush
      end
    end

    context 'no call' do
      let(:text) do
        <<-RUBY
def foo; end # method definition
local = 1    # local variable
:foo         # symbol
'foo'        # string literal
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

    context 'call :foo & :bar' do
      let(:text) do
        <<~RUBY
foo
bar
        RUBY
      end

      it 'returns foo and bar' do
        expect(subject.size).to eq 2
        expect(subject[0].mid).to eq :foo
        expect(subject[1].mid).to eq :bar
      end

      context 'with block' do
        let(:searcher) do
          CallSearcher::Searcher.new do |method_call|
            method_call.mid == :foo
          end
        end

        it 'returns only matched elements' do
          expect(subject.size).to eq 1
          expect(subject[0].mid).to eq :foo
        end
      end
    end
  end
end
