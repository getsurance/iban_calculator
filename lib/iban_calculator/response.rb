require 'dry-initializer'
require 'dry-types'

module IbanCalculator
  class Response
    extend Dry::Initializer

    CONCLUSIVENESS_THRESHOLD = 32
    CORRECTNESS_THRESHOLD = 127

    option :result, Dry::Types['strict.string']
    option :return_code, Dry::Types['coercible.int']
    option :iban, Dry::Types['coercible.string'], optional: true
    option :country, Dry::Types['coercible.string'], optional: true
    option :bank_code, Dry::Types['coercible.string'], optional: true
    option :bank, Dry::Types['coercible.string'], optional: true
    option :account_number, Dry::Types['coercible.string'], optional: true
    option :iban_url, Dry::Types['coercible.string'], optional: true
    option :balance, Dry::Types['coercible.int'], optional: true

    def valid?
      return_code < CORRECTNESS_THRESHOLD && result == 'passed'
    end

    def conclusive?
      return_code < CONCLUSIVENESS_THRESHOLD && !blacklisted?
    end

    def blacklisted?
      iban_url == 'IBAN_BLACKLISTED'
    end
  end
end
