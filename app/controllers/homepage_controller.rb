class HomepageController < ApplicationController
  include HTTParty
  BASE_URI = 'https://min-api.cryptocompare.com/data/pricemulti'
  HISTORIC_URI = 'https://min-api.cryptocompare.com/data/histohour'
  DEFAULT_CURRENCIES = 'USD,AUD,CNY'
  DEFAULT_COINS = 'BTC,ETH,LTC'
  DENOMINATION = 'USD'
  
  def index
    # GET request to external API service - returns JSON
    @data = HTTParty.get(BASE_URI,
            query: { fsyms: DEFAULT_COINS, tsyms: DEFAULT_CURRENCIES })
            
    # historic data - return data (exluding metadata) parsed as ruby hash
    # https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD
    @historic_data = HTTParty.get(HISTORIC_URI,
                     query: { fsym: 'BTC', tsym: 'USD' }).parsed_response['Data']
    
    @denomination = DENOMINATION
     
    # chartkick wants to receive an array as [coin_code, price]
    @chart_data = Array.new([])
    # For each coin get its price in the given denomination
    @data.each do |key, value|
      entry = [key, value[DENOMINATION]]
      @chart_data.push(entry)
    end
    
    # {Time => Price}
    @timeseries_data = Hash.new
    @historic_data.each do |entry|
      # For each timestamp (key) store the close price (value)
      # Also we must convert Unix time to Ruby DateTime
      @timeseries_data[Time.at(entry["time"])] = entry["close"]
    end
    
  end
end


