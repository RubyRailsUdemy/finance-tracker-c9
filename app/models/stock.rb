class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  
  def self.new_from_lookup(ticker_symbol)
    begin
      looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
      last_price = strip_commas(looked_up_stock.l)
      new(name: looked_up_stock.name, ticker: looked_up_stock.symbol, last_price: last_price)
    rescue Exception => e
      return nil
    end
  end
  
  def self.strip_commas(number)
    number.gsub(",", "")
  end
end
