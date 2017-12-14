module IbanCalculator
  class ValidateIban
    OPERATION = :validate_iban

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def call(iban)
      client.(OPERATION, iban: iban)
    end
  end
end
