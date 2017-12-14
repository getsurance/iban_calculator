require 'dry-struct'

module IbanCalculator
  class Response < Dry::Struct::Value
    attribute :result, Dry::Types['strict.string']
    attribute :return_code, Dry::Types['coercible.int']
    attribute :iban, Dry::Types['strict.string'].optional
    attribute :country, Dry::Types['strict.string'].optional
    attribute :bank_code, Dry::Types['strict.string'].optional
    attribute :bank, Dry::Types['strict.string'].optional
    attribute :account_number, Dry::Types['strict.string'].optional
  end
end
