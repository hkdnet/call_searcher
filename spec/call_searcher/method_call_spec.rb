RSpec.describe CallSearcher::MethodCall do
  subject { CallSearcher::MethodCall.new(node: node, context: CallSearcher::Context.new) }
  let(:node) { RubyVM::AbstractSyntaxTree.parse(text).children.last }

  describe 'basic attributes: type, mid, receiver' do
    context :VCALL do
      let(:text) { 'foo' }

      it do
        expect(subject.type).to eq :VCALL
        expect(subject.mid).to eq :foo
        expect(subject.receiver).to be nil
      end
    end

    context :FCALL do
      let(:text) { 'foo(1)' }

      it do
        expect(subject.type).to eq :FCALL
        expect(subject.mid).to eq :foo
        expect(subject.receiver).to be nil
      end
    end

    context :CALL do
      let(:text) { 'foo.bar' }

      it do
        expect(subject.type).to eq :CALL
        expect(subject.mid).to eq :bar
        expect(subject.receiver).not_to be nil
      end
    end

    context :QCALL do
      let(:text) { 'foo&.bar' }

      it do
        expect(subject.type).to eq :QCALL
        expect(subject.mid).to eq :bar
        expect(subject.receiver).not_to be nil
      end
    end

    context :OPCALL do
      let(:text) { '1 + 2' }

      it do
        expect(subject.type).to eq :OPCALL
        expect(subject.mid).to eq :+
        expect(subject.receiver).not_to be nil
      end
    end
  end
end
