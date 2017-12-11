require 'iban_calculator/version'
require 'active_support/configurable'
require 'active_support/core_ext/hash'
require 'logger'

require 'iban_calculator/bank'
require 'iban_calculator/bic_candidate'
require 'iban_calculator/calculate_iban'
require 'iban_calculator/iban_validator_response'
require 'iban_calculator/invalid_data'
require 'iban_calculator/active_support' if ActiveSupport::VERSION::MAJOR == 3

module IbanCalculator
  # Extensions
  include ActiveSupport::Configurable

  # Configuration
  config_accessor(:url) { 'https://ssl.ibanrechner.de/soap/?wsdl' }
  config_accessor(:user) { '' }
  config_accessor(:password) { '' }
  config_accessor(:logger) { Logger.new(STDOUT) }

  # Errors
  ServiceError = Class.new(StandardError)

  class << self
    def calculate_iban(attributes = {})
      calculator = CalculateIban.new(config.user, config.password, client, config.logger)
      calculator.call(attributes)
    end

    def validate_iban(iban)
      response = execute(:validate_iban, iban: iban, user: config.user, password: config.password)
      IbanValidatorResponse.new(response.body[:validate_iban_response][:return])
    end

    def execute(method, options = {})
      client.call(method, message: options).tap do |response|
        status = response.body[:"#{method}_response"][:return][:result]
        fail(ServiceError, status) unless response.body[:"#{method}_response"][:return][:return_code]
      end
    end

    private

    def client
      @client ||= Savon.client(wsdl: config.url, logger: config.logger)
    end
  end
end
