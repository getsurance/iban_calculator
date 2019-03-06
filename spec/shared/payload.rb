RSpec.shared_context 'payload' do
  let(:valid_payload) do
    {
      iban: 'DE59120300001111236988',
      result: 'passed',
      return_code: '0',
      ibanrueck_return_code: {
        "@xsi:type": 'xsd:string'
      },
      checks: {
        item: %w[length bank_code account_number],
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'xsd:string[3]'
      },
      bic_candidates: {
        item: {
          bic: 'BYLADEM1001',
          zip: '10117',
          city: 'Berlin',
          wwwcount: '0',
          sampleurl: { "@xsi:type": 'xsd:string' },
          "@xsi:type": 'tns:BICStruct'
        },
        "@xsi:type": 'SOAP-ENC:Array',
        "@soap_enc:array_type": 'tns:BICStruct[1]'
      },
      country: 'DE',
      bank_code: '12030000',
      alternative_bank_code: { "@xsi:type": 'xsd:string' },
      bank: 'Deutsche Kreditbank Berlin',
      bank_address: { "@xsi:type": 'xsd:string' },
      bank_url: { "@xsi:type": 'xsd:string' },
      branch: { "@xsi:type": 'xsd:string' },
      branch_code: { "@xsi:type": 'xsd:string' },
      in_scl_directory: 'yes',
      sct: 'yes',
      sdd: 'yes',
      b2b: 'yes',
      account_number: '1011856976',
      alternative_account_number: { "@xsi:type": 'xsd:string' },
      account_validation_method: '00',
      account_validation: 'Methode 00, Konto 1111236988, BLZ 12030000, Prüfziffer 6 steht an Position 10, erwartete Prüfziffer: 6. Überblick über die Berechnung: Nimm die Ziffern auf den Positionen 1 bis 9 - hier: 1111236988 -, multipliziere sie von rechts nach links mit den Gewichten 2,1,2,1,2,1,2,1,2, addiere die Quersummen der Produkte, bilde den Rest der Division durch 10, ziehe das Ergebnis von 10 ab,  und das Ergebnis modulo 10 ist die erwartete Prüfziffer.',
      length_check: 'passed',
      account_check: 'passed',
      bank_code_check: 'passed',
      bic_plausibility_check: { "@xsi:type": 'xsd:string' },
      data_age: '20140525',
      iba_nformat: 'DEkk BBBB BBBB CCCC CCCC CC',
      formatcomment: 'B = sort code (BLZ), C = account No.',
      balance: '4',
      "@xsi:type": 'tns:IBANCalcResStruct'
    }
  end
end
