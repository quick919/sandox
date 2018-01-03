require_relative './ExpressionInterface'

class Sum < ExpressionInterface
  attr_accessor :augend, :addend
  
  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end

  def reduce(bank,to)
    amount = @augend.reduce(bank, to).amount + @addend.reduce(bank, to).amount
    return Money.new(amount, to)
  end

  def plus(addend)
    return Sum.new(self, addend)
  end

  def times(multiplier)
    return Sum.new(augend.times(multiplier), addend.times(multiplier))
  end
end