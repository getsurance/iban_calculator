require 'iban_calculator/iban_validator_response'

module IbanCalculator
  class ValidateIban
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def call(iban)
      client.(:validate_iban, iban: iban)
    end
  end
end
