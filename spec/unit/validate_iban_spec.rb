require 'iban_calculator/validate_iban'

RSpec.describe IbanCalculator::ValidateIban do
  include_context 'response'

  let(:logger) { double.as_null_object }
  let(:client) { spy(call: response, logger: logger) }
  let(:response) { build_valid_response(balance: 1000) }

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

    it 'does not log warning' do
      expect(logger).not_to receive(:warn).with(/99/)
      subject.('iban')
    end

    context 'low balance' do
      let(:client) { spy(call: response, logger: logger) }
      let(:response) { build_valid_response(balance: 99) }

      it 'logs warning' do
        expect(logger).to receive(:warn).with(/99/)
        subject.('iban')
      end
    end
  end
end
