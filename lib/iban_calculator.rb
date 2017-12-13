require 'iban_calculator/version'
require 'dry-configurable'
require 'logger'

require 'iban_calculator/bank'
require 'iban_calculator/bic_candidate'
require 'iban_calculator/calculate_iban'
require 'iban_calculator/iban_validator_response'
require 'iban_calculator/invalid_data'

module IbanCalculator
  extend Dry::Configurable

  setting :url, 'https://ssl.ibanrechner.de/soap/?wsdl'
  setting :user, ''
  setting :password, ''
  setting :logger, Logger.new(STDOUT)

  ServiceError = Class.new(StandardError)

  class << self
    def calculate_iban(attributes = {})
      calculator = CalculateIban.new(config.user, config.password, client, config.logger)
      calculator.(attributes)
    end

    def validate_iban(iban)
      response = execute(:validate_iban, iban: iban, user: config.user, password: config.password)
      IbanValidatorResponse.new(response.body[:validate_iban_response][:return])
    end

    def execute(method, options = {})
      client.(method, message: options).tap do |response|
        status = response.body[:"#{method}_response"][:return][:result]
        raise ServiceError, status unless response.body[:"#{method}_response"][:return][:return_code]
      end
    end

    private

    def client
      @client ||= Client.new(wsdl: config.url, logger: config.logger)
    end
  end
end
