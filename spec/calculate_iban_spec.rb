RSpec.describe IbanCalculator::CalculateIban do
  include_context 'payload'

  subject { described_class.new(instance_double(IbanCalculator::Client), Logger.new(STDOUT)) }

  before { allow(subject.logger).to receive(:info) }

  describe '#italian_account_number' do
    it 'returns an empty hash if not all fields are provided' do
      expect(subject.italian_account_number).to eq({})
    end

    it 'returns hash with correct account number if valid data is provided' do
      expect(
        subject.italian_account_number(
          'country' => 'IT',
          'cab' => '03280',
          'abi' => '03002',
          'cin' => 'D',
          'account' => '400162854')
      ).to eq('account' => 'D0300203280000400162854')
    end
  end

  describe '#iban_payload' do
    context 'italian data is provided' do
      before { allow(subject).to receive(:italian_account_number).and_return({ 'account' => 'italy-123' }) }

      it 'normalizes italian account data' do
        subject.iban_payload({})
        expect(subject).to have_received(:italian_account_number)
      end

      it 'merges italian data' do
        expect(subject.iban_payload({ 'country' => 'IT' })).to match(hash_including(account: 'italy-123'))
      end

      it 'strips italian data' do
        expect(subject.iban_payload({ 'cin' => '123' }).keys).to_not include('cin')
      end
    end

    it 'adds default payload' do
      expect(subject.iban_payload({}).keys).to include(:legacy_mode)
    end

    it 'overrides default data' do
      expect(subject.iban_payload({ bank_code: '123' })).to match hash_including(bank_code: '123')
    end

    it 'replaces account_number with account' do
      expect(subject.iban_payload({ account_number: '123' })).to match hash_including(account: '123')
    end
  end

  describe '#call' do
    let(:response) { double(body: { calculate_iban_response: { return: valid_payload } }) }

    before { allow(subject.client).to receive(:call).and_return(response) }

    it 'calls the client with the generated payload' do
      subject.call({})
      expect(subject.client).to have_received(:call).with(:calculate_iban, message: anything)
    end
  end
end
