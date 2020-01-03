require 'net/http'
require 'json'
require 'date'

class Lw23ScrappingService
    def initialize

        url = "https://www.lw23.nl/en/realtime-listings/consumer"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @data = JSON.parse(response)

        # remove sales from data
        @data = only_rentals

        # amsterdam AND haarlem
        @amsterdam, @haarlem = filter_by_city

        # filter by Amsterdam and Haarlem
        @data = @amsterdam + @haarlem
    end

    def get_all_appartments
        pretty_print(@data)
    end

    def total_appartments_in(city = 'Amsterdam')
        city == 'Amsterdam' ? @amsterdam.count : @haarlem.count
    end

    def pretty_print(data: nil, city: 'Amsterdam')
        raw_data = if !data
            city == 'Amsterdam' ? @amsterdam : @haarlem
        else
            data
        end
        return [] if data.count == 0

        pretty_data = []
        keys = ["url", "city", "photo", "address", "price", "rentalsPrice", "bedrooms", "added"]
        raw_data.each do |hash,value|
            pretty_data << hash.reject {|k,v| !keys.include?(k)}
            pretty_data.last['added'] = DateTime.strptime(pretty_data.last['added'].to_s,'%s')
        end

        pretty_data
    end

    def search(params = {price: 999999, city: 'Amsterdam'})
        maxPrice = params[:price]
        city = params[:city]

        #filter by city
        data = city == 'Amsterdam' ? @amsterdam : @haarlem

        #filter by price
        data = data.select {|k,v| k['rentalsPrice'].to_i <= maxPrice }

        { results: pretty_print(data: data), total: data.count }
    end

    def appartments_added_today
        today = Date.today

        unix_time_beginning_of_day = Date.parse("#{Time.now.strftime('%d/%m/%Y')} 00:00:00").to_time.to_i

        recent_listings = @data.select { |k,v| k['added'] > unix_time_beginning_of_day }
        { results: pretty_print(data: recent_listings), total: recent_listings.count }
    end

    private

    def only_rentals
        @data.select {|k,v| k['isRentals'] == true }
    end

    def filter_by_city
        amsterdam = []
        haarlem = []

        haarlem = @data.select {|k,v| k['city'] == 'Haarlem' }
        amsterdam = @data.select {|k,v| k['city'] == 'Amsterdam' }
        [amsterdam, haarlem]
    end
end