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
