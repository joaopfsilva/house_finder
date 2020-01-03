require 'twilio-ruby'

class TwilioService

    def initialize
        # put your own credentials here
        account_sid = ENV['TWILIO_ACCOUNT_SID']
        auth_token = ENV['TWILIO_AUTH_TOKEN']
        # set up a client to talk to the Twilio REST API
        @client = Twilio::REST::Client.new(account_sid, auth_token)
    end

    def send_sms(message: 'Hey there!')
        @client.messages.create(
            from: ENV['TWILIO_PHONE_NUMBER'],
            to: '+14698285677',
            body: 'Hey there!'
        )
    end

end