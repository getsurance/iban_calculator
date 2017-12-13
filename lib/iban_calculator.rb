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
      iban_calculator.(attributes)
    end

    def validate_iban(iban)
      response =
        client.(:validate_iban, message: { iban: iban }).tap do |resp|
          status = resp.body[:"#{method}_response"][:return][:result]
          raise ServiceError, status unless resp.body[:"#{method}_response"][:return][:return_code]
        end

      IbanValidatorResponse.new(response.body[:validate_iban_response][:return])
    end

    private

    def iban_calculator
      @iban_calculator ||= CalculateIban.new(client, config.logger)
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
