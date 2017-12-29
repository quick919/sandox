class Franc
  attr_accessor :amount
  def initialize(amount)
    @amount = amount
  end

  def times(multiplier)
    return Franc.new(@amount * multiplier)
  end

  def ==(other)
    @amount == other.amount
  end
end