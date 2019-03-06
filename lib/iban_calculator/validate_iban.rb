module IbanCalculator
  class ValidateIban
    OPERATION = :validate_iban

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def call(iban)
      response = client.(OPERATION, iban: iban)
      process_response(response)
    end

    private

    def process_response(response)
      log_balance(response.balance)
      response
    end

    def log_balance(balance)
      if balance && balance < balance_threshold
        client.logger.warn("IBAN_CALCULATOR: Running out of credits. Current balance is: #{balance}.")
      end
    end

    def balance_threshold
      100
    end
  end
end
