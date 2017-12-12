require 'savon'
require_relative 'response'

module IbanCalculator
  class Client
    VALID_RESPONSE_CODE = 0..31
    PROBABLY_VALID_RESPONSE_CODE = 32..127
    SERVICE_ERROR_RESPONSE_CODE = 65536

    def initialize(args = {})
      @adapter = Savon.client(args)
    end

    def call(operation, args = {})
      raw_response = adapter.(operation, args)
      response = raw_response.body["#{operation}_response".to_sym][:return]

      case return_code = response[:return_code].to_i
      when VALID_RESPONSE_CODE
        formatted_result(response)
      when PROBABLY_VALID_RESPONSE_CODE
        formatted_result(response)
      when SERVICE_ERROR_RESPONSE_CODE
        raise ServiceError, 'Service could not handle the request'
      else
        raise InvalidData.new('Invalid input data', return_code)
      end
    end

    def formatted_result(data)
      { iban: data[:iban],
        bics: process_bic_candidates(data[:bic_candidates]),
        country: data[:country],
        bank_code: data[:bank_code],
        bank: data[:bank],
        account_number: data[:account_number],
        updated_at: Date.parse(data[:data_age]) }
    end

    def process_bic_candidates(candidates)
      [candidates[:item].select { |key, value| %i[bic zip city].include?(key) && value.is_a?(String) }]
    rescue StandardError
      raise ArgumentError, 'Could not handle BIC response'
    end

    private

    attr_reader :adapter
  end
end
