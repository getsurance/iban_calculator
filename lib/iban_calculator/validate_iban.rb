require 'iban_calculator/iban_validator_response'

module IbanCalculator
  class ValidateIban
    attr_reader :client, :logger

    def initialize(client, logger)
      @client = client
      @logger = logger
    end

    def call(iban)
      response =
        client.(:validate_iban, iban: iban).tap do |resp|
          status = resp.body[:validate_iban_response][:return][:result]
          raise ServiceError, status unless resp.body[:validate_iban_response][:return][:return_code]
        end

      IbanValidatorResponse.new(response.body[:validate_iban_response][:return])
    end
  end
end
