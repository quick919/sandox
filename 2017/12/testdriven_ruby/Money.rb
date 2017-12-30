class Money
  attr_accessor :amount, :currency
  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def ==(other_money)
    @amount == other_money.amount && self.class.equal?(other_money.class)
  end
  
  def self.dollar(amount)
    return Dollar.new(amount, "USD")
  end

  def self.franc(amount)
    return Franc.new(amount, "CHF")
  end

  def times(multiplier)
  end

  def currency
    return @currency
  end
end