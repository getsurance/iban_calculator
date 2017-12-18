RSpec.describe IbanCalculator do
  include_context 'response'

  let(:response) { build_valid_response(operation) }

  before { allow_any_instance_of(Savon::Client).to receive(:call).and_return(response) }

  describe '.validate_bank_info' do
    let(:operation) { :calculate_iban }

    it 'calls the iban_calculator with arguments' do
      calculator = spy
      allow(described_class).to receive(:bank_info_validator).and_return(calculator)

      described_class.validate_bank_info({})

      expect(calculator).to have_received(:call).with(hash_including(:country, :bank_code, :account_number))
    end

    context 'valid response' do
      it 'returns a response object' do
        expect(subject.validate_bank_info(country: 'DE', bank_code: 'code', account_number: 'number')).to be_a(IbanCalculator::Response)
      end
    end
  end

  describe '.validate_iban' do
    let(:operation) { :validate_iban }

    let(:validator) { spy }

    it 'calls the iban_validator with arguments' do
      allow(described_class).to receive(:iban_validator).and_return(validator)
      described_class.validate_iban('arguments')

      expect(validator).to have_received(:call).with('arguments')
    end

    context 'valid response' do
      it 'returns a response object' do
        expect(subject.validate_iban(iban: 'DE121212121211212')).to be_a(IbanCalculator::Response)
      end
    end
  end
end
