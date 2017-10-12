require 'minitest/autorun'
require 'webmock/minitest'
require 'globe_labs'

describe 'GlobeLabs::Main' do
  before do
    @key = 'key'
    @secret = 'secret'
    @short_code = '1234'
    @globe = GlobeLabs::Client.new(key: @key, secret: @secret, short_code: @short_code)
    @code = 'code'
    @auth_host = 'https://developer.globelabs.com.ph'
    @response_body = {body: {key: 'value'}.to_json, headers: {'Content-Type' => 'application/json;charset=utf-8'}}
    @response_object = {"key" => 'value'}
  end

  describe '#get_access_token' do
    it 'returns access token and subscriber' do
      body = "app_id=#@key&app_secret=#@secret&code=#@code"
      stub_post("#@auth_host/oauth/access_token", body)
      @globe.get_access_token(@code).must_equal @response_object
    end
  end

  private
  def stub_post(url, body)
    headers = {'Content_type' => "application/x-www-form-urlencoded"}
    body = WebMock::Util::QueryMapper.query_to_values(body)
    @request = stub_request(:post, url).with(body: body, headers: headers).to_return(@response_body)
  end
end
