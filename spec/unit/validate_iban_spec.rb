require 'iban_calculator/validate_iban'

RSpec.describe IbanCalculator::ValidateIban do
  include_context 'response'

  let(:client) { spy(call: response) }
  let(:response) { build_valid_response(:validate_iban) }

  subject { described_class.new(client) }

  describe '#call' do
    it 'calls client with correct operation' do
      subject.('iban')
      expect(client).to have_received(:call).with(:validate_iban, be_a(Hash))
    end

    it 'includes iban in the message' do
      subject.('iban')
      expect(client).to have_received(:call).with(:validate_iban, hash_including(iban: 'iban'))
    end
  end
end
