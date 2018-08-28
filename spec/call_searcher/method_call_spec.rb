RSpec.describe CallSearcher::MethodCall do
  subject { CallSearcher::MethodCall.new(node) }
  let(:node) { RubyVM::AST.parse(text).children.last }
  context 'NODE_VCALL' do
    let(:text) do
      <<-RUBY
foo
      RUBY
    end

    it do
      expect(subject.type).to eq 'NODE_VCALL'
      expect(subject.mid).to eq :foo
      expect(subject.recv_node).to be nil
      expect(subject.args).to eq []
    end
  end
  context 'NODE_FCALL' do
    let(:text) do
      <<-RUBY
foo(1)
      RUBY
    end

    it do
      expect(subject.type).to eq 'NODE_FCALL'
      expect(subject.mid).to eq :foo
      expect(subject.recv_node).to be nil
      expect(subject.args).to eq [1]
    end
  end

  context 'NODE_CALL' do
    let(:text) do
      <<-RUBY
foo.bar
      RUBY
    end

    it do
      expect(subject.type).to eq 'NODE_CALL'
      expect(subject.mid).to eq :bar
      expect(subject.recv_node).not_to be nil
      expect(subject.args).to eq []
    end
  end

  context 'NODE_QCALL' do
    let(:text) do
      <<-RUBY
foo&.bar('a')
      RUBY
    end

    it do
      expect(subject.type).to eq 'NODE_QCALL'
      expect(subject.mid).to eq :bar
      expect(subject.recv_node).not_to be nil
      expect(subject.args).to eq ['a']
    end
  end
end
