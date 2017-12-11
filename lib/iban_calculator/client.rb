require 'savon'

module IbanCalculator
  class Client
    def initialize(args = {})
      @adapter = Savon.client(args)
    end

    def call(operation, args = {})
      @adapter.call(operation, args)
    end

    # def execute(method, options = {})
    #   call(method, message: options).tap do |response|
    #     status = response.body[:"#{method}_response"][:return][:result]
    #     fail(ServiceError, status) unless response.body[:"#{method}_response"][:return][:return_code]
    #   end
    # end
  end
end
