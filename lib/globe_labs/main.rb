require 'net/https'
require 'net/http'
require 'json'

module GlobeLabs
  class Main
    attr_accessor :key, :secret, :access_token

    def initialize(options = {})
      @key = options.fetch(:key)
      @secret = options.fetch(:secret)
      @short_code = options[:sender_address]
      @auth_host = options.fetch(:auth_host) { 'developer.globelabs.com.ph' }
      @api_host = options.fetch(:api_host) { 'devapi.globelabs.com.ph' }
      @version = options.fetch(:version) { 'v1' }
    end

    def get_access_token(code)
      post(@auth_host, '/oauth/access_token', {app_id: @key,
                                               app_secret: @secret,
                                               code: code})
    end

    private
    def get(host, request_uri, params = {}, content_type = 'x-www-form-urlencoded')
      uri = URI('https://' + host + request_uri)
      uri.query = Params.encode(params)

      message = Net::HTTP::Get.new(uri.request_uri, 'Content-Type' => "application/#{content_type}")

      case content_type
      when 'json'
        message.body = params.to_json
      else
        message.form_data = params
      end

      request(uri, message)
    end

    def post(host, request_uri, params, content_type = 'x-www-form-urlencoded')
      uri = URI('https://' + host + request_uri)
      message = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => "application/#{content_type}")

      case content_type
      when 'json'
        message.body = params.to_json
      else
        message.form_data = params
      end

      request(uri, message)
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      http_response = http.request(message)

      case http_response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        return (yield http_response) if block_given?

        if http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body)
        else
          http_response.body
        end
      when Net::HTTPUnauthorized
        raise AuthenticationError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPClientError
        http_response.body
        #raise ClientError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPServerError
        raise ServerError, "#{http_response.code} response from #{uri.host}"
      else
        raise Error, "#{http_response.code} response from #{uri.host}"
      end
    end
  end
end
