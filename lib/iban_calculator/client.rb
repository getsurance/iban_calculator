require 'savon'

module IbanCalculator
  class Client
    def initialize(args = {})
      @adapter = Savon.client(args)
    end

    def call(operation, args = {})
      @adapter.call(operation, args)
    end
  end
end
