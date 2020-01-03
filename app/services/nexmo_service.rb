

require 'nexmo'

class NexmoService
    def initialize
        @client = Nexmo::Client.new(
            api_key: ENV['NEXMO_API_KEY'],
            api_secret: ENV['NEXMO_SECRET_KEY']
        )
    end

    def send_sms(message: 'Hello bitches!!')
        @client.sms.send(
            from: "HouseAI",
            to: "351919598325",
            text: message
        )

    end
end