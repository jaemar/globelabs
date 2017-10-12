require 'minitest/autorun'
require 'webmock/minitest'
require 'globe_labs'


describe 'GlobeLabs::Client' do
  before do
    @key = 'key'
    @secret = 'secret'
    @short_code = '1234'
    @token = 'token'
    @number = '9951234567'
    @message = 'your sample message'
    @globe = GlobeLabs::Client.new(key: @key, secret: @secret, short_code: @short_code)
    @api_host = 'https://devapi.globelabs.com.ph'
    @response_body = {body: {key: 'value'}.to_json, headers: {'Content-Type' => 'application/json;charset=utf-8'}}
    @response_object = {"key" => 'value'}
  end

  # TODO SEND MESSAGE
  describe '#send_message' do
    it 'returns response object' do
      random = rand(10 ** 6)
      body = {
        "outboundSMSMessageRequest": {
          "clientCorrelator": "#{random}",
          "senderAddress": "#{@short_code}",
          "outboundSMSTextMessage": {"message": "#{@message}"},
          "address": "tel:+63#{@number}"
        }
      }
      @globe.stub(:rand, random) do
        stub_post("#@api_host/smsmessaging/v1/outbound/#@short_code/requests?access_token=#@token", body.to_json, 'json')
        @globe.send_message(@token, @number, @message).must_equal @response_object
      end
    end
  end

  describe '#send_sms_uri' do
    it 'returns send_sms_uri' do
      @globe.send(:send_sms_uri, @token).must_equal '/smsmessaging/v1/outbound/1234/requests?access_token=token'
    end
  end

  describe '#build_send_message_params' do
    it 'returns build_send_message_params' do
      response_object = {
        outboundSMSMessageRequest: {
          clientCorrelator: "123456",
          senderAddress: "1234",
          outboundSMSTextMessage: { message: "your sample message" },
          address: "tel:+63#{@number}"
        }
      }

      @globe.stub(:rand, 123456) do
        @globe.send(:build_send_message_params, @number, @message).must_equal response_object
      end
    end
  end

  # LOCATE
  describe '#locate' do
    it 'fetch user current location' do
      stub_get("#@api_host/location/v1/queries/location?access_token=#@token&address=0#@number&requestedAccuracy=100", 'json')
      @globe.locate(@token, @number).must_equal @response_object
    end
  end

  describe '#locate_uri' do
    it 'returns locate_uri' do
      @globe.send(:locate_uri).must_equal '/location/v1/queries/location'
    end
  end

  describe '#build_locate_params' do
    it 'returns build_locate_params' do
      response_object = {
        access_token: @token,
        address: "0#{@number}",
        requestedAccuracy: "100"
      }
      @globe.send(:build_locate_params, @token, @number).must_equal response_object
    end
  end

  # CHARGE
  describe '#charge' do
    it 'returns response object' do
      options = {
        amount: "100",
        description: 'sample description',
        endUserId: "#{@number}",
        referenceCode: "1234567",
        transactionOperationStatus: 'Charged'
      }

      body = "amount=100&description=sample description&endUserId=tel:%2B63#@number&referenceCode=#{@short_code}1234567&transactionOperationStatus=Charged"

      stub_post("#@api_host/payment/v1/transactions/amount?access_token=#@token", body)
      @globe.charge(@token, options).must_equal @response_object
    end
  end

  describe '#charge_uri' do
    it 'returns charge_uri' do
      @globe.send(:charge_uri, 'token').must_equal '/payment/v1/transactions/amount?access_token=token'
    end
  end

  describe '#build_charge_params' do
    it 'returns build_charge_params' do
      params = {
        amount: 100,
        description: "description",
        endUserId: @number,
        referenceCode: "1234567",
        transactionOperationStatus: 'Charged'
      }

      response_object = {
        amount: 100,
        description: "description",
        endUserId: "tel:+63#{@number}",
        referenceCode: "#{@short_code}1234567",
        transactionOperationStatus: 'Charged'
      }

      @globe.send(:build_charge_params, params).must_equal response_object
    end
  end

  # REFERENCE_CODE
  describe '#last_reference_code' do
    it 'fetch last reference code (charge)' do
      stub_get("#@api_host/payment/v1/transactions/getLastRefCode?app_id=#@key&app_secret=#@secret")
      @globe.last_reference_code.must_equal @response_object
    end

  end
  describe '#reference_code_uri' do
    it 'returns reference_code_uri' do
      @globe.send(:reference_code_uri).must_equal '/payment/v1/transactions/getLastRefCode'
    end
  end

  private
  def stub_get(url, content_type = 'x-www-form-urlencoded')
    headers = {'Content_type' => "application/#{content_type}"}
    @request = stub_request(:get, url).with(headers: headers).to_return(@response_body)
  end

  def stub_post(url, body, content_type = 'x-www-form-urlencoded')
    headers = {'Content_type' => "application/#{content_type}"}
    body = WebMock::Util::QueryMapper.query_to_values(body) unless content_type == 'json'
    @request = stub_request(:post, url).with(body: body, headers: headers).to_return(@response_body)
  end
end
