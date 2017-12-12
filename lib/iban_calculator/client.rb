require 'savon'

module IbanCalculator
  class Client
    def initialize(args = {})
      @adapter = Savon.client(args)
    end

    def call(operation, args = {})
      @adapter.(operation, args)
    end
  end
end
