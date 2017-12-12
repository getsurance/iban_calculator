# IbanCalculator

A wrapper for ibanrechner.de API. It allows converting bank account data from legacy syntax to new SEPA IBAN/BIC.

## Installation

Add this line to your application's Gemfile:

    gem 'iban_calculator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iban_calculator

## Usage

In order to use iban calculator, you need to create an account at [iban-bic.com](http://www.iban-bic.com/).

Configuration can be done with a block:

```ruby
IbanCalculator.configure do |config|
  config.user =     'username',
  config.password = 'password'
  config.logger =   Logger.new(STDERR)
end
```

Whenever you need to convert European legacy account data to new SEPA IBAN format:

```ruby
IbanCalculator.calculate_iban country: 'DE', account_number: '123', bank_code: '456'
```

Example data can be found at: http://www.iban-bic.com/sample_accounts.html

You can also validate a given IBAN and fetch additional data about it:

```ruby
IbanCalculator.validate_iban 'AL90208110080000001039531801'
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/iban_calculator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
