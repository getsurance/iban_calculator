RSpec.describe IbanCalculator::Response do
  include_context 'response'

  subject { described_class.new(response) }

  describe '#return_code' do
    let(:response) { valid_response.merge(return_code: '123') }

    it 'gets return code from input data' do
      expect(subject.return_code).to eq 123
    end

    it 'is an integer' do
      expect(subject.return_code).to be_an(Integer)
    end

    it 'has to be present' do
      expect { described_class.new(response.merge(return_code: '')) }.to raise_error(ArgumentError)
    end
  end

  describe '#result' do
    let(:response) { valid_response.merge(result: 'something') }

    it 'equals result field in response' do
      expect(subject.result).to eq 'something'
    end
  end

  describe '#valid?' do
    it 'is invalid if return_code > 127' do
      subject = described_class.new(return_code: 128, result: 'passed')

      expect(subject.valid?).to eq false
    end

    it 'is invalid if result is not "passed"' do
      subject = described_class.new(result: 'not_passed', return_code: 0)

      expect(subject.valid?).to eq false
    end
  end

  describe '#conclusive?' do
    context 'return_code is below the conclusiveness threshold' do
      let(:return_code) { described_class::CONCLUSIVENESS_THRESHOLD - 1 }

      it 'is conclusive ' do
        subject = described_class.new(return_code: return_code, result: 'passed')
        expect(subject.conclusive?).to eq true
      end
    end

    context 'return_code is above the conclusiveness threshold' do
      let(:return_code) { described_class::CONCLUSIVENESS_THRESHOLD }

      it 'is inconclusive' do
        subject = described_class.new(return_code: return_code, result: 'passed')
        expect(subject.conclusive?).to eq false
      end
    end

    context 'marked as blacklisted' do
      it 'is inconclusive' do
        subject = described_class.new(return_code: 0, result: 'passed')
        allow(subject).to receive(:blacklisted?).and_return(true)
        expect(subject.conclusive?).to eq false
      end
    end
  end

  describe '#blacklisted?' do
    it 'checks if url matches expected blacklist token' do
      subject = described_class.new(iban_url: 'IBAN_BLACKLISTED', result: 'passed', return_code: 0)
      expect(subject.blacklisted?).to eq true
    end
  end
end
