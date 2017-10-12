# globelabs
Ruby wrapper for [GlobeLabs](http://www.globelabs.com.ph/) API

Add to Gemfile
```ruby
gem 'globelabs'
```
then

	$ bundle install

or

	$ gem install globe_labs


## Usage
#### Initialize
```ruby
require 'globelabs'

globelabs = GlobeLabs::Client.new(key: 'app_id', secret: 'app_secret', send_address: 'short_code')
```

#### [Get Access Token](http://www.globelabs.com.ph/docs/#getting-started-opt-in-via-webform)
_note: skip this part if you already have the access token_

```ruby
globelabs.get_access_token(code)

# =>
#  {
#    "access_token":"1ixLbltjWkzwqLMXT-8UF-UQeKRma0hOOWFA6o91oXw",
#    "subscriber_number":"9171234567"
#  }
```

#### [Send Message](http://www.globelabs.com.ph/docs/#sms-sending-sms-sms-mt)
Send an SMS message to one or more mobile terminals:
```ruby
globelabs.send_message(token, subscriber_number, message)

# =>
#  {
#   "outboundSMSMessageRequest": {
#     "address": "tel:+639175595283",
#     "deliveryInfoList": {
#       "deliveryInfo": [],
#       "resourceURL": "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/8011/requests?access_token=3YM8xurK_IPdhvX4OUWXQljcHTIPgQDdTESLXDIes4g"
#     },
#     "senderAddress": "8011",
#     "outboundSMSTextMessage": {
#       "message": "Hello World"
#     },
#     "receiptRequest": {
#       "notifyURL": "http://test-sms1.herokuapp.com/callback",
#       "callbackData": null,
#       "senderName": null,
#       "resourceURL": "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/8011/requests?access_token=3YM8xurK_IPdhvX4OUWXQljcHTIPgQDdTESLXDIes4g"
#     }
#   }
#  }
```

#### [Locate](http://www.globelabs.com.ph/docs/#location-based-services-resources-and-uris)
Locate a subscriber’s location:
```ruby
globelabs.locate(token, subscriber_number)

# =>
#  {
#    "terminalLocationList": {
#      "terminalLocation": {
#        "address": "tel:9171234567",
#        "currentLocation": {
#          "accuracy": 100,
#          "latitude": "14.5609722",
#          "longitude": "121.0193394",
#          "map_url": "http://maps.google.com/maps?z=17&t=m&q=loc:14.5609722+121.0193394",
#          "timestamp": "Fri Jun 06 2014 09:25:15 GMT+0000 (UTC)"
#        },
#        "locationRetrievalStatus": "Retrieved"
#      }
#    }
#  }
```

#### [Charge](http://www.globelabs.com.ph/docs/#charging-charge-subscriber)
Charge/bill a subscriber:
```ruby
options = {
  amount: "20",
  description: "sample description",
  endUserId: "915xxxxxxx",
  reference_code: '1234567',
  transactionOperationStatus: 'Charged'
}

globelabs.charge(token, options)

# =>
#  {
#   "amountTransaction":
#   {
#     "endUserId": "9171234567",
#     "paymentAmount":
#     {
#       "chargingInformation":
#       {
#         "amount": "0.00",
#         "currency": "PHP",
#         "description": "my application"
#       },
#       "totalAmountCharged": "0.00"
#     },
#     "referenceCode": "12341000023",
#     "serverReferenceCode": "528f5369b390e16a62000006",
#     "resourceURL": null
#    }
#  }
```

#### [Last Reference Code](http://www.globelabs.com.ph/docs/#charging-get-last-reference-code)
In case you lost of track of your reference code:
```ruby
globelabs.last_reference_code

# =>
# {
#    "referenceCode": "12341000005",
#    "status": "SUCCESS",
#    "shortcode": "21581234"
#  }
```


## Contributing

1. Fork it ( https://github.com/jaemar/globelabs/fork )
2. Create your feature branch (`git checkout -b feature/new_feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new_feature`)
5. Create a new Pull Request
