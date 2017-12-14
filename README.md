# IbanCalculator

A wrapper for ibanrechner.de API. It allows converting bank account data from legacy syntax to new SEPA IBAN/BIC.

## Installation

Add this line to your application's Gemfile:

    gem 'iban_calculator', git: 'https://github.com/getsurance/iban_calculator'

And then execute:

    $ bundle

## Usage

In order to use this gem, you first need to create an account at [iban-bic.com](http://www.iban-bic.com/).

Configuration can be done with a block:

```ruby
IbanCalculator.configure do |config|
  config.user =     'username',
  config.password = 'password'
  config.logger =   Logger.new(STDERR)
end
```

You can validate an IBAN:

```ruby
IbanCalculator.validate_iban('AL90208110080000001039531801')
```

You can validate bank info:

```ruby
IbanCalculator.validate_bank_info(country: 'DE', account_number: '123', bank_code: '456')
```

Example data can be found at: http://www.iban-bic.com/sample_accounts.html


Validations return a `IbanCalculator::Response` object that can be queried:
```ruby
response = IbanCalculator.validate_iban('AL90208110080000001039531801')

response.valid? # true or false

response.conclusive? # if the response is valid but not conclusive you might want to check it manually.
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/iban_calculator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
