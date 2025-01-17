require 'ringcentral'
require 'subscription'
require 'dotenv'
require 'rspec'

Dotenv.load
$rc = RingCentral.new(ENV['RINGCENTRAL_CLIENT_ID'], ENV['RINGCENTRAL_CLIENT_SECRET'], ENV['RINGCENTRAL_SERVER_URL'])

RSpec.describe 'PubNub Subscription' do
  def createSubscription(callback)
    events = [
      '/restapi/v1.0/account/~/extension/~/message-store',
    ]
    subscription = PubNub.new($rc, events, lambda { |message|
      callback.call(message)
    })
    subscription.subscribe()
    return subscription
  end

  describe 'PubNub Subscription' do
    it 'receives message notification' do
      $rc.authorize(jwt: ENV['RINGCENTRAL_JWT_TOKEN'])
      count = 0
      createSubscription(lambda { |message|
        count += 1
      })

      $rc.post('/restapi/v1.0/account/~/extension/~/sms', payload: {
        to: [{phoneNumber: ENV['RINGCENTRAL_RECEIVER']}],
        from: {phoneNumber: ENV['RINGCENTRAL_SENDER']},
        text: 'Hello world'
      })
      sleep(20)

      expect(count).to be > 0
      $rc.revoke()
    end

    it 'refresh' do
      $rc.authorize(jwt: ENV['RINGCENTRAL_JWT_TOKEN'])
      count = 0
      subscription = createSubscription(lambda { |message|
        count += 1
      })

      subscription.refresh()

      $rc.post('/restapi/v1.0/account/~/extension/~/sms', payload: {
        to: [{phoneNumber: ENV['RINGCENTRAL_RECEIVER']}],
        from: {phoneNumber: ENV['RINGCENTRAL_SENDER']},
        text: 'Hello world'
      })
      sleep(20)

      expect(count).to be > 0
      $rc.revoke()
    end

    it 'revoke' do
      $rc.authorize(jwt: ENV['RINGCENTRAL_JWT_TOKEN'])
      count = 0
      subscription = createSubscription(lambda { |message|
        count += 1
      })

      subscription.revoke()

      $rc.post('/restapi/v1.0/account/~/extension/~/sms', payload: {
        to: [{phoneNumber: ENV['RINGCENTRAL_RECEIVER']}],
        from: {phoneNumber: ENV['RINGCENTRAL_SENDER']},
        text: 'Hello world'
      })
      sleep(20)

      expect(count).to eq(0)
      $rc.revoke()
    end
  end
end
