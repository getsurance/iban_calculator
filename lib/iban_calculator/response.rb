require 'dry-struct'

module IbanCalculator
  class Response < Dry::Struct::Value
    CONCLUSIVENESS_THRESHOLD = 32
    CORRECTNESS_THRESHOLD = 127

    constructor_type :schema

    attribute :result, Dry::Types['strict.string']
    attribute :return_code, Dry::Types['coercible.int']
    attribute :iban, Dry::Types['strict.string'].optional
    attribute :country, Dry::Types['strict.string'].optional
    attribute :bank_code, Dry::Types['strict.string'].optional
    attribute :bank, Dry::Types['strict.string'].optional
    attribute :account_number, Dry::Types['strict.string'].optional

    def valid?
      return_code < CORRECTNESS_THRESHOLD && result == 'passed'
    end

    def conclusive?
      return_code < CONCLUSIVENESS_THRESHOLD
    end
  end
end
