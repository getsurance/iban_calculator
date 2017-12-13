RSpec.describe IbanCalculator do
  describe '.calculate_iban' do
    let(:calculator) { spy }

    it 'calls the iban_calculator with arguments' do
      allow(described_class).to receive(:iban_calculator).and_return(calculator)
      described_class.calculate_iban('arguments')

      expect(calculator).to have_received(:call).with('arguments')
    end
  end

  describe '.validate_iban' do
    let(:validator) { spy }

    it 'calls the iban_validator with arguments' do
      allow(described_class).to receive(:iban_validator).and_return(validator)
      described_class.validate_iban('arguments')

      expect(validator).to have_received(:call).with('arguments')
    end
  end
end
