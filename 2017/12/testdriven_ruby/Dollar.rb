class Dollar
  attr_accessor :amount
  def initialize(amount)
    @amount = amount
  end

  def times(multiplier)
    return Dollar.new(@amount * multiplier)
  end

  def ==(other_franc)
    @amount == other_franc.amount
  end
end