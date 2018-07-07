class HomepageController < ApplicationController
  include HTTParty
  BASE_URI = 'https://min-api.cryptocompare.com/data/pricemulti'
  DEFAULT_CURRENCIES = 'USD,AUD,CNY'
  DEFAULT_COINS = 'BTC,ETH,LTC'
  
  def index
    # GET request to external API service - returns JSON
    @data = HTTParty.get(BASE_URI,
            query: { fsyms: DEFAULT_COINS, tsyms: DEFAULT_CURRENCIES })
  end
end
