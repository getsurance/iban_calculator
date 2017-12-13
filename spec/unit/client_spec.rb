RSpec.describe IbanCalculator::Client do
  include_context 'payload'
  include_context 'response'

  subject { described_class.new(wsdl: '') }


  describe '#call' do
    let(:adapter) { spy(call: response) }
    let(:operation) { :some_operation }
    let(:response) { build_valid_response(operation) }

    before { allow(subject).to receive(:adapter).and_return(adapter) }

    it 'calls the adapter with correct arguments' do
      subject.call(operation, { a: :message })
      expect(adapter).to have_received(:call).with(operation, { a: :message })
    end

    xit 'returns a response object' do
      expect(subject.(operation, valid_payload)).to be_a IbanCalculator::Response
    end

    context 'valid response' do
      it 'returns a formatted response' do
        allow(subject).to receive(:formatted_result)
        subject.call(operation, {})
        expect(subject).to have_received(:formatted_result)
      end
    end

    context 'invalid response' do
      let(:response) { double(body: { calculate_iban_response: { return: valid_payload.merge(return_code: '128') } }) }

      xit 'logs a message' do
        subject.call({}) rescue IbanCalculator::InvalidData
        expect(subject.logger).to have_received(:info).with(/iban check invalid/)
      end

      it 'fails with invalid data exception' do
        expect { subject.call(:calculate_iban)}.to raise_exception(IbanCalculator::InvalidData)
      end
    end

    context 'server error response' do
      let(:response) { double(body: { calculate_iban_response: { return: valid_payload.merge(return_code: '65536') } }) }

      xit 'logs a message' do
        subject.call({}) rescue IbanCalculator::ServiceError
        expect(subject.logger).to have_received(:info).with(/iban check failed/)
      end

      it 'fails with service error exception' do
        expect{ subject.call(:calculate_iban) }.to raise_exception(IbanCalculator::ServiceError)
      end
    end

    context 'probably valid response' do
      let(:response) { double(body: { calculate_iban_response: { return: valid_payload.merge(return_code: '32') } }) }

      xit 'logs a message' do
        subject.call({}) rescue IbanCalculator::InvalidData
        expect(subject.logger).to have_received(:info).with(/needs manual check/)
      end
    end
  end

  describe '#process_bic_candidates' do
    context 'known single BIC payload' do
      let(:payload) { valid_payload[:bic_candidates] }

      it 'returns an array' do
        expect(subject.process_bic_candidates(payload)).to be_kind_of(Array)
      end

      it 'returns its bank\'s bic' do
        expect(subject.process_bic_candidates(payload).first).to match hash_including(bic: 'BYLADEM1001')
      end

      it 'returns its bank\'s zip' do
        expect(subject.process_bic_candidates(payload).first).to match hash_including(zip: '10117')
      end

      it 'returns its bank\'s city' do
        expect(subject.process_bic_candidates(payload).first).to match hash_including(city: 'Berlin')
      end

      context 'empty fields' do
        let(:payload) { {:item=>{
                            :bic=>"UNCRITMM",
                            :zip=>{:"@xsi:type"=>"xsd:string"},
                            :city=>{:"@xsi:type"=>"xsd:string"},
                            :wwwcount=>"0",
                            :sampleurl=>{:"@xsi:type"=>"xsd:string"},
                            :"@xsi:type"=>"tns:BICStruct"
                          },
                          :"@xsi:type"=>"SOAP-ENC:Array",
                          :"@soap_enc:array_type"=>"tns:BICStruct[1]"} }

        it 'ignores empty zip' do
          expect(subject.process_bic_candidates(payload).first.keys).to_not include(:zip)
        end

        it 'ignores empty city' do
          expect(subject.process_bic_candidates(payload).first.keys).to_not include(:city)
        end
      end
    end

    context 'unknown payload' do
      let(:payload) { { :items => [], :"@xsi:type" => 'SOAP-ENC:Array' } }

      xit 'logs the payload' do
        subject.process_bic_candidates(payload) rescue
        expect(subject.logger).to have_received(:info)
      end

      it 'raises an exception' do
        expect { subject.process_bic_candidates(payload) }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '#formatted_result' do
    before { allow(subject).to receive(:process_bic_candidates).and_return(['data']) }

    it 'returns a valid ruby date for last update date' do
      expect(subject.formatted_result(valid_payload)[:updated_at]).to be_kind_of(Date)
    end

    it 'transforms the list of bic candidates' do
      subject.formatted_result(valid_payload)
      expect(subject).to have_received(:process_bic_candidates)
    end

    it 'includes iban' do
      expect(subject.formatted_result(valid_payload).keys).to include(:iban)
    end
  end
end
