require 'iban_calculator/validate_iban'

RSpec.describe IbanCalculator::ValidateIban do
  include_context 'response'

  let(:client) { spy(call: response) }
  let(:response) { build_valid_response(:validate_iban) }

  subject { described_class.new(client, double) }
  describe '#call' do
    it 'calls client with correct message' do
      subject.('iban')
      expect(client).to have_received(:call).with(:validate_iban, be_a(Hash))
    end

    it 'includes iban in the message' do
      subject.('iban')
      expect(client).to have_received(:call).with(:validate_iban, message: (hash_including(iban: 'iban')))
    end

    context 'valid response' do
      it 'returns response object' do
        expect(subject.('iban')).to be_a(IbanCalculator::IbanValidatorResponse)
      end
    end
  end
end
