require 'savon'
require_relative 'response'

module IbanCalculator
  class Client
    attr_reader :logger

    SERVICE_ERROR_RETURN_CODE = 65536

    def initialize(user:, password:, logger: Logger.new(STDOUT), adapter_options: {})
      @user = user
      @password = password
      @logger = logger
      @adapter = Savon.client(adapter_options)
    end

    def call(operation, payload = {})
      raw_response = adapter.(operation, message: payload.merge(credentials))
      response = Response.new(raw_response.body["#{operation}_response".to_sym][:return])

      response.return_code == SERVICE_ERROR_RETURN_CODE ? raise(ServiceError) : response
    end

    private

    def credentials
      { user: user, password: password }
    end

    attr_reader :adapter, :user, :password
  end
end
