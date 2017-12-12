describe IbanCalculator do
  describe '.execute' do
    context 'invalid username and password' do
      let(:error_message) { 'User someone, password test: invalid username-password combination' }
      let(:response) { { failing_response: { return: { result: error_message } } } }

      before { allow_any_instance_of(Savon::Client).to receive(:call) { double(body: response) } }

      it 'raises a generic exception' do
        expect { IbanCalculator.execute(:failing) }.to raise_error(IbanCalculator::ServiceError, error_message)
      end
    end
  end
end
