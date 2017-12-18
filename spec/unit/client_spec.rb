RSpec.describe IbanCalculator::Client do
  include_context 'payload'
  include_context 'response'

  subject { described_class.new(user: 'user', password: 'password', adapter_options: { wsdl: '' }) }

  describe '#call' do
    let(:adapter) { spy(call: response) }
    let(:operation) { :some_operation }
    let(:response) { build_valid_response(operation) }

    before { allow(subject).to receive(:adapter).and_return(adapter) }

    it 'calls the adapter with correct arguments' do
      subject.call(operation, a: :message)
      expect(adapter).to have_received(:call).with(operation, message: hash_including(a: :message))
    end

    it 'includes credentials in adapter call' do
      subject.call(operation, a: :message)
      expect(adapter).to have_received(:call).with(operation, message: hash_including(user: 'user', password: 'password'))
    end

    it 'returns a response object' do
      expect(subject.(operation, valid_payload)).to be_a IbanCalculator::Response
    end

    context 'server error response' do
      let(:response) { double(body: { calculate_iban_response: { return: valid_payload.merge(return_code: '65536') } }) }

      it 'fails with service error exception' do
        expect{ subject.call(:calculate_iban) }.to raise_exception(IbanCalculator::ServiceError)
      end
    end
  end
end
