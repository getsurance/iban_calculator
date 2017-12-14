RSpec.shared_context 'bic_candidate' do
  def single_candidate
    {
      :item => {
        :bic => 'BOFIIE2D',
        :zip => 'zip',
        :city => 'city',
        :wwwcount => '0',
        :sampleurl => 'sample_url',
        :'@xsi:type' => 'tns:BICStruct'
      },
      :'@xsi:type' => 'SOAP-ENC:Array',
      :'@soap_enc:array_type' => 'tns:BICStruct[1]'
    }
  end

  def multiple_candidates
    {
      :item => [{
        :bic => 'BOFIIE2D',
        :zip => 'zip',
        :city => 'city',
        :wwwcount => '0',
        :sampleurl => 'sample_url',
        :'@xsi:type' => 'tns:BICStruct'
      }, {
        :bic => 'BOFIIE2D',
        :zip => 'zip',
        :city => 'city',
        :wwwcount => '0',
        :sampleurl => 'sample_url',
        :'@xsi:type' => 'tns:BICStruct'
      }],
      :'@xsi:type' => 'SOAP-ENC:Array',
      :'@soap_enc:array_type' => 'tns:BICStruct[1]'
    }
  end
end
