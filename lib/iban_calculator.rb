require 'iban_calculator/version'
require 'dry-configurable'

require 'iban_calculator/errors'
require 'iban_calculator/validate_bank_info'
require 'iban_calculator/validate_iban'

module IbanCalculator
  extend Dry::Configurable

  setting :url, 'https://ssl.ibanrechner.de/soap/?wsdl'
  setting :user, ''
  setting :password, ''
  setting :logger, Logger.new(STDOUT)

  class << self
    def validate_bank_info(attributes = {})
      bank_info_validator.(
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

    def bank_info_validator
      @bank_info_validator ||= ValidateBankInfo.new(client)
    end

    def iban_validator
      @iban_validator ||= ValidateIban.new(client)
    end

    def client
      @client ||= Client.new(
        user: config.user,
        password: config.password,
        logger: config.logger,
        adapter_options: {
          wsdl: config.url,
          logger: config.logger
        }
      )
    end
  end
end
