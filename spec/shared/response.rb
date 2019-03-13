require 'iban_calculator/response'

RSpec.shared_context 'response' do
  def build_valid_response(params = {})
    IbanCalculator::Response.new(valid_response.merge(params))
  end

  def build_invalid_response(params = {})
    IbanCalculator::Response.new(invalid_response.merge(params))
  end

  def build_valid_raw_response(operation)
    base_with(operation, valid_response)
  end

  def build_invalid_raw_response(operation)
    base_with(operation, invalid_response)
  end

  def base_with(operation, response)
    double(body: { "#{operation}_response".to_sym => { return: response } })
  end

  let(:valid_response) do
    {
      iban: 'IE92BOFI90001710027952',
      result: 'passed',
      return_code: '0',
      checks: {
        item: %w[length bank_code account_number iban_checksum],
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'xsd:string[4]'
      },
      bic_candidates: {
        item: {
          bic: 'BOFIIE2D',
          zip: { "@xsi:type": 'xsd:string' },
          city: { "@xsi:type": 'xsd:string' },
          wwwcount: '0',
          sampleurl: { "@xsi:type": 'xsd:string' },
          "@xsi:type": 'tns:BICStruct'
        },
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'tns:BICStruct[1]'
      },
      country: 'IE',
      bank_code: '90-00-17',
      bank: 'Bank of Ireland',
      bank_address: 'Dublin 2 ',
      bank_url: { "@xsi:type": 'xsd:string' },
      branch: { "@xsi:type": 'xsd:string' },
      branch_code: { "@xsi:type": 'xsd:string' },
      in_scl_directory: 'no',
      sct: { "@xsi:type": 'xsd:string' },
      sdd: { "@xsi:type": 'xsd:string' },
      b2b: { "@xsi:type": 'xsd:string' },
      account_number: '10027952',
      account_validation_method: { "@xsi:type": 'xsd:string' },
      account_validation: { "@xsi:type": 'xsd:string' },
      length_check: 'passed',
      account_check: 'passed',
      bank_code_check: 'passed',
      iban_checksum_check: 'passed',
      data_age: '20140706',
      iba_nformat: 'IEkk AAAA BBBB BBCC CCCC CC',
      formatcomment: 'The first 4 alphanumeric characters are the start of the SWIFT code. Then a 6 digit long routing code and an 8 digit account code follow, both numeric.',
      balance: '1000',
      "@xsi:type": 'tns:IBANValResStruct'
    }
  end

  let(:invalid_response) do
    {
      iban: 'IE92BOFI900017100',
      result: 'failed',
      return_code: '512',
      checks: {
        item: 'length',
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'xsd:string[1]'
      },
      bic_candidates: {
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'tns:BICStruct[0]'
      },
      country: 'IE',
      bank_code: { "@xsi:type": 'xsd:string' },
      bank: { "@xsi:type": 'xsd:string' },
      bank_address: { "@xsi:type": 'xsd:string' },
      bank_url: { "@xsi:type": 'xsd:string' },
      branch: { "@xsi:type": 'xsd:string' },
      branch_code: { "@xsi:type": 'xsd:string' },
      in_scl_directory: 'no',
      sct: { "@xsi:type": 'xsd:string' },
      sdd: { "@xsi:type": 'xsd:string' },
      b2b: { "@xsi:type": 'xsd:string' },
      account_number: { "@xsi:type": 'xsd:string' },
      account_validation_method: { "@xsi:type": 'xsd:string' },
      account_validation: { "@xsi:type": 'xsd:string' },
      length_check: 'failed',
      account_check: { "@xsi:type": 'xsd:string' },
      bank_code_check: { "@xsi:type": 'xsd:string' },
      iban_checksum_check: { "@xsi:type": 'xsd:string' },
      data_age: { "@xsi:type": 'xsd:string' },
      iba_nformat: 'IEkk AAAA BBBB BBCC CCCC CC',
      formatcomment: 'The first 4 alphanumeric characters are the start of the SWIFT code. Then a 6 digit long routing code and an 8 digit account code follow, both numeric.',
      balance: '0',
      "@xsi:type": 'tns:IBANValResStruct'
    }
  end
end
