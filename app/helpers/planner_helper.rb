#require 'HTTParty'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class PlannerHelper
    CITY = {
        'KZN': {
           lat: 55.797128, 
           lng: 49.112287,
           address: 'Kazan, Russia'
        },
        'MOW': {
           lat: 55.751414,
           lng: 37.617411,
           address: 'Moscow, Russia'
        },
        'HEL': {
           lat: 60.168242, 
           lng: 24.938483,
           address: 'Helsinki, Finland'
        },
        'WAW': {
          lat: 52.228318, 
          lng: 21.035013,
          address: 'Warsaw, Poland'
        },
        'BER': {
          lat: 52.517199, 
          lng: 13.403105,
          address: 'Berlin, Germany'
        },
        'PRG': {
          lat: 50.073990, 
          lng: 14.427959,
          address: 'Prague, Czech Republic'
        },
        'LED': {
          lat: 59.929437, 
          lng: 30.321643,
          address: 'Saint Petersburg, Russia'
        }
    }
    
    def self.flights(origin, destination, date)
        data = []
        if true
            begin 
                response = HTTParty.get('https://travelpayouts-travelpayouts-flight-data-v1.p.rapidapi.com/v2/prices/month-matrix',
                    headers: {
                        'X-RapidAPI-Host': 'travelpayouts-travelpayouts-flight-data-v1.p.rapidapi.com',
                        'X-RapidAPI-Key': '7ea3cff523mshb192672c404fa45p155c23jsnb87518699367',
                        'X-Access-Token': '6e5cc7307ac456f4dc8d1aed350b7efa'
                    },
                    query: {
                        'origin': origin,
                        'destination': destination,
                        'month': '2019-07-01',
                        'currency': 'USD'
                    },
                )
                data = JSON.parse(response.body)['data']
            rescue => ex
                data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'flights', origin + destination + '.json')))['data']
            end
        else
            data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'flights', origin + destination + '.json')))['data']           
        end

        return data.select{|f| f['depart_date'] == date}
    end

    def self.buses(origin, destination, date)
        data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'buses', origin + destination + '.json')))
        return data.select{|f| f['departure_at'][0..9] == date}           
    end

    def self.trains(origin, destination, date)
        data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'trains', origin + destination + '.json')))
        return data.select{|f| f['departure_at'][0..9] == date}           
    end
    
    def self.car_transfer(destination)
        data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'transfer', 'cars', destination + '.json')))
        return data         
    end

    def self.hotels(destination, arrival, departure)
        data = []
        if true 
            begin
                response = HTTParty.get("https://apidojo-booking-v1.p.rapidapi.com/properties/list",
                    headers: {
                        'X-RapidAPI-Host': 'apidojo-booking-v1.p.rapidapi.com',
                        'X-RapidAPI-Key': '7ea3cff523mshb192672c404fa45p155c23jsnb87518699367',
                    },
                    query: {
                        'arrival_date': arrival,
                        'departure_date': departure,
                        'latitude': CITY[destination.to_sym][:lat],
                        'longitude': CITY[destination.to_sym][:lng],
                        'search_type': 'latlong',
                        'price_filter_currencycode': 'USD'
                    },
                )
                data = JSON.parse(response.body)
            rescue => ex
                data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'hotels', destination + '.json')))
            end
        else
            data = JSON.parse(File.read(Rails.root.join('lib', 'data', 'hotels', destination + '.json')))
        end

        res = []
        data['result'].each do |hotel|
            begin
                res << {
                    name: hotel['hotel_name'],
                    lat: hotel['latitude'],
                    lng: hotel['longitude'],
                    address: hotel['address'],
                    price: hotel['price_breakdown']['gross_price'].to_i,
                    currency: hotel['price_breakdown']['currency'],
                    score: hotel['review_score']
                }
            rescue => ex
            end
        end
        return res
    end
end