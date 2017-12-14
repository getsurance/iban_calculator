require 'iban_calculator/version'
require 'dry-configurable'
require 'logger'

require 'iban_calculator/bank'
require 'iban_calculator/errors'
require 'iban_calculator/bic_candidate'
require 'iban_calculator/calculate_iban'
require 'iban_calculator/validate_iban'
require 'iban_calculator/iban_validator_response'

module IbanCalculator
  extend Dry::Configurable

  setting :url, 'https://ssl.ibanrechner.de/soap/?wsdl'
  setting :user, ''
  setting :password, ''
  setting :logger, Logger.new(STDOUT)

  class << self
    def calculate_iban(attributes = {})
      iban_calculator.(
        country: attributes[:country],
        bank_code: attributes[:bank_code],
        account_number: attributes[:account_number],
        cin: attributes[:cin],
        abi: attributes[:abi],
        cab: attributes[:cab]
      )
    end

    def validate_iban(iban)
      iban_validator.(iban)
    end

    private

    def iban_calculator
      @iban_calculator ||= CalculateIban.new(client)
    end

    def iban_validator
      @iban_validator ||= ValidateIban.new(client)
    end

    def client
      @client ||= Client.new(
        user: config.user,
        password: config.password,
        adapter_options: {
          wsdl: config.url,
          logger: config.logger
        }
      )
    end
  end
end
