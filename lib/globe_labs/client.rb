module GlobeLabs
  class Client < Main
    def send_message(token, number, message)
      post(@api_host, send_sms_uri(token), build_send_message_params(number, message), 'json')
    end

    def locate(token, number)
      get(@api_host, locate_uri, build_locate_params(token, number), 'json')
    end

    def charge(token, options = {})
      post(@api_host, charge_uri(token), build_charge_params(options))
    end

    def last_reference_code
      get(@api_host, reference_code_uri, {app_id: @key,
                                           app_secret: @secret})
    end

    private
    def send_sms_uri(token)
      "/smsmessaging/#{@version}/outbound/#{@short_code}/requests?access_token=#{token}"
    end

    def build_send_message_params(number, message)
      {
        "outboundSMSMessageRequest": {
          "clientCorrelator": "#{rand(10 ** 6)}",
          "senderAddress": "#{@short_code}",
          "outboundSMSTextMessage": {"message": "#{message}"},
          "address": "tel:+63#{number}"
        }
      }
    end

    def locate_uri
      "/location/#{@version}/queries/location"
    end

    def build_locate_params(token, number)
      {
        "access_token": token,
        "address": "0#{number}",
        "requestedAccuracy": "100"
      }
    end

    def charge_uri(token)
      "/payment/v1/transactions/amount?access_token=#{token}"
    end

    def build_charge_params(options)
      {
        amount: options[:amount],
        description: options[:description],
        endUserId: "tel:+63#{options[:endUserId]}",
        referenceCode: "#{@short_code}#{options[:referenceCode]}",
        transactionOperationStatus: 'Charged'
      }
    end

    def reference_code_uri
      '/payment/v1/transactions/getLastRefCode'
    end
  end
end
