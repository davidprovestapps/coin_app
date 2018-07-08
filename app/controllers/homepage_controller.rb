class HomepageController < ApplicationController
  include HTTParty
  BASE_URI = 'https://min-api.cryptocompare.com/data/pricemulti'
  DEFAULT_CURRENCIES = 'USD,AUD,CNY'
  DEFAULT_COINS = 'BTC,ETH,LTC'
  DENOMINATION = 'USD'
  
  def index
    # GET request to external API service - returns JSON
    @data = HTTParty.get(BASE_URI,
            query: { fsyms: DEFAULT_COINS, tsyms: DEFAULT_CURRENCIES })
            
    # chartkick wants to receive an array as [coin_code, price]
    @chart_data = Array.new([])
    # For each coin get its price in the given denomination
    @data.each do |key, value|
      entry = [key, value[DENOMINATION]]
      @chart_data.push(entry)
    end
  end
end
