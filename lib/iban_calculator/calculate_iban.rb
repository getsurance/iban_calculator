require_relative 'client'

# Return codes and their meaning:
#
# 0 = all checks were successful
#
# 1 = sub account number has been added automatically
# 2 = account number did not include a checksum
# 4 = checksum has not been checked
# 8 = bank code has not been checked
#
# 32 = A sub account number might be required, but could not be determined autoamtically
#
# 128 = checksum for account_number is invalid
# 256 = bank_code could not be found is database
# 512 = account_number has an invalid length
# 1024 = bank_code has an invalid length
# 4096 = data is missing (i.e. country code)
# 8192= country is not yet supported

module IbanCalculator
  class CalculateIban
    ITALIAN_IBAN_LENGTH = 27
    PREFIX_AND_CHECKSUM_LENGTH = 4

    attr_accessor :user, :password, :client, :logger

    def initialize(user, password, client, logger)
      @user = user
      @password = password
      @client = client
      @logger = logger
    end

    # You should provide country, bank_code, and account_number. (cin, abi, and cab for Italian accounts)
    def call(attributes)
      payload = iban_payload(attributes)

      response = client.(:calculate_iban, message: payload)
      log "iban lookup attributes=#{attributes} payload=#{payload} response=#{response}"

    end

    def italian_account_number(attributes = {})
      return {} unless attributes['country'].to_s.casecmp('IT').zero?
      left_length = ITALIAN_IBAN_LENGTH - PREFIX_AND_CHECKSUM_LENGTH - attributes['account'].length
      left_side = [attributes['cin'], attributes['abi'], attributes['cab']].join.ljust(left_length, '0')
      { 'account' => left_side + attributes['account'] }
    end

    def default_payload
      { country: '', bank_code: '', account: '', user: user, password: password, bic: '', legacy_mode: 0 }
    end

    def iban_payload(attributes)
      attributes = attributes.with_indifferent_access
      attributes['account'] = attributes.delete('account_number')
      normalized_attributes = attributes.merge(italian_account_number(attributes))
      payload = normalized_attributes.select { |k, _| %w[country account bank_code].include?(k) }
      default_payload.merge(payload.symbolize_keys)
    end

    def log(message)
      logger.info message
    end
  end
end
