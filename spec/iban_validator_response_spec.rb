RSpec.describe IbanCalculator::IbanValidatorResponse do
  include_context 'response'

  let(:valid) { described_class.new(valid_response) }
  let(:invalid) { described_class.new(invalid_response) }

  describe '#valid?' do
    it 'returns true if response is valid' do
      expect(valid.valid?).to eq(true)
    end

    it 'returns false if response is not valid' do
      expect(invalid.valid?).to eq(false)
    end
  end

  describe '#return_code' do
    it 'returns its code' do
      expect(valid.return_code).to eq(0)
    end
  end

  describe '#bic_candidates' do
    it 'returns an array' do
      expect(valid.bic_candidates).to be_instance_of(Array)
    end
  end

  describe '#bank' do
    it 'returns a bank hash' do
      expect(valid.bank).to be_instance_of(IbanCalculator::Bank)
    end

    it 'returns bank name' do
      expect(valid.bank.name).to eq('Bank of Ireland')
    end

    it 'returns bank address' do
      expect(valid.bank.address).to eq('Dublin 2')
    end

    it 'returns bank code' do
      expect(valid.bank.code).to eq('90-00-17')
    end

    it 'returns bank country' do
      expect(valid.bank.country).to eq('IE')
    end

    it 'returns bank url' do
      expect(valid.bank.url).to eq('')
    end

    it 'returns bank branch' do
      expect(valid.bank.branch).to eq('')
    end

    it 'returns bank branch_code' do
      expect(valid.bank.branch_code).to eq('')
    end
  end

  describe '#account_number' do
    it 'returns its account number' do
      expect(valid.account_number).to eq('10027952')
    end
  end

  describe '#checks' do
    context 'valid response' do
      it 'returns a hash of checks and their results' do
        expect(valid.checks).to eq(
          length: 'passed',
          bank_code: 'passed',
          account_number: 'passed',
          iban_checksum: 'passed'
        )
      end
    end

    context 'invalid response' do
      it 'returns a hash of checks and their results' do
        expect(invalid.checks).to eq(
          length: 'failed',
          bank_code: 'not_checked',
          account_number: 'not_checked',
          iban_checksum: 'not_checked'
        )
      end
    end
  end

  describe '#updated_at' do
    it 'returns a proper date object' do
      expect(valid.updated_at).to eq(Date.new(2014, 0o7, 0o6))
    end

    it 'is nil for invalid response' do
      expect(invalid.updated_at).to eq(nil)
    end
  end

  describe '#errors' do
    context 'valid response' do
      it 'returns an empty array' do
        expect(valid.errors).to eq({})
      end
    end

    context 'invalid response' do
      it 'returns an empty array' do
        expect(invalid.errors).to eq(account_number: [:invalid_length])
      end
    end
  end

  describe '#as_json' do
    it 'returns an hash with all attributes' do
      expect(valid.as_json).to eq(
        'valid' => true,
        'errors' => {},
        'account_number' => '10027952',
        'bank' => 'Bank of Ireland',
        'bank_code' => '90-00-17',
        'bics' => [{ 'bic' => 'BOFIIE2D', 'zip' => '', 'city' => '', 'sample_url' => '', 'www_count' => 0 }],
        'checks' => { 'length' => 'passed', 'account_number' => 'passed', 'bank_code' => 'passed', 'iban_checksum' => 'passed' },
        'updated_at' => Date.new(2014, 7, 6)
      )
    end

    it 'also returns errors for invalid response' do
      expect(invalid.as_json).to eq(
        'valid' => false,
        'errors' => { 'account_number' => [:invalid_length] },
        'account_number' => nil,
        'bank' => '',
        'bank_code' => '',
        'bics' => [],
        'checks' => { 'length' => 'failed', 'account_number' => 'not_checked', 'bank_code' => 'not_checked', 'iban_checksum' => 'not_checked' },
        'updated_at' => nil
      )
    end
  end
end
