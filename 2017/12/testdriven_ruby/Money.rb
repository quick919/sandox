class Money
  attr_accessor :amount

  def ==(other_money)
    @amount == other_money.amount && self.class.equal?(other_money.class)
  end
  
  def self.dollar(amount)
    return Dollar.new(amount)
  end

  def self.franc(amount)
    return Franc.new(amount)
  end

  def times(multiplier)
  end
end