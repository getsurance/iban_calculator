require 'savon'
require_relative 'response'

module IbanCalculator
  class Client
    VALID_RETURN_CODE = 0..31
    PROBABLY_VALID_RETURN_CODE = 32..127
    SERVICE_ERROR_RETURN_CODE = 65536

    def initialize(user:, password:, adapter_options: {})
      @user = user
      @password = password
      @adapter = Savon.client(adapter_options)
    end

    def call(operation, payload = {})
      raw_response = adapter.(operation, message: payload.merge(credentials))
      old_response = raw_response.body["#{operation}_response".to_sym][:return]

      response = Response.new(old_response)

      case response.return_code
      when VALID_RETURN_CODE
        response
      when PROBABLY_VALID_RETURN_CODE
        response
      when SERVICE_ERROR_RETURN_CODE
        raise ServiceError, 'Service could not handle the request'
      else
        raise InvalidData.new('Invalid input data', response.return_code)
      end
    end

    private

    def credentials
      { user: user, password: password }
    end

    attr_reader :adapter, :user, :password
  end
end
