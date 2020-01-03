namespace :lw23 do
  desc "TODO"
  task check_new_listings: :environment do
    data = Lw23ScrappingService.new

    # puts "Total appartmens in Amsterdam: #{data.total_appartments_in('Amsterdam')}"
    # puts "Total appartmens in Haarlem: #{data.total_appartments_in('Haarlem')}"

    # params = {price: 1200, city: 'Haarlem'}
    # results = data.search(params)

    # puts "Found #{results[:total]} appartments in #{params[:city]} up to #{params[:price]}€"
    # puts JSON.pretty_generate results[:results]

    recent_listings = data.appartments_added_today
    # puts "Found #{recent_listings[:total]} added today"
    # puts JSON.pretty_generate recent_listings[:results]
    NexmoService.new.send_sms(message: "Found #{recent_listings[:total]} added today")
  end
end