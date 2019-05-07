RSpec.describe CallSearcher::MethodCall do
  subject { CallSearcher::MethodCall.new(node: node) }
  let(:node) { RubyVM::AbstractSyntaxTree.parse(text).children.last }
  context :VCALL do
    let(:text) do
      <<~RUBY
foo
      RUBY
    end

    it do
      expect(subject.type).to eq :VCALL
      expect(subject.mid).to eq :foo
      expect(subject.receiver).to be nil
    end
  end
  context :FCALL do
    let(:text) do
      <<~RUBY
foo(1)
      RUBY
    end

    it do
      expect(subject.type).to eq :FCALL
      expect(subject.mid).to eq :foo
      expect(subject.receiver).to be nil
    end
  end

  context :CALL do
    let(:text) do
      <<~RUBY
foo.bar
      RUBY
    end

    it do
      expect(subject.type).to eq :CALL
      expect(subject.mid).to eq :bar
      expect(subject.receiver).not_to be nil
    end
  end

  context :QCALL do
    let(:text) do
      <<~RUBY
foo&.bar('a')
      RUBY
    end

    it do
      expect(subject.type).to eq :QCALL
      expect(subject.mid).to eq :bar
      expect(subject.receiver).not_to be nil
    end
  end

  context :OPCALL do
    let(:text) do
      <<~RUBY
1 + 2
      RUBY
    end

    it do
      expect(subject.type).to eq :OPCALL
      expect(subject.mid).to eq :+
      expect(subject.receiver).not_to be nil
    end
  end
end
