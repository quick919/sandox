require_relative './ExpressionInterface'
require_relative './Sum'

class Money < ExpressionInterface
  attr_accessor :amount, :currency
  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def ==(other_money)
    @amount == other_money.amount && @currency == other_money.currency
  end
  
  def self.dollar(amount)
    return Money.new(amount, "USD")
  end

  def self.franc(amount)
    return Money.new(amount, "CHF")
  end

  def times(multiplier)
    return Money.new(@amount * multiplier, currency)
  end

  def currency
    return @currency
  end

  def plus(addend)
    return Sum.new(self, addend)
  end

  def reduce(bank,to)
    rate = bank.rate(@currency, to)
    return Money.new(@amount / rate, to)
  end
end