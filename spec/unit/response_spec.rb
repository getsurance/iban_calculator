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
end
