require_relative './ExpressionInterface'

class Sum < ExpressionInterface
  attr_accessor :augend, :addend
  
  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end

  def reduce(to)
    amount = @augend.amount + @addend.amount
    return Money.new(amount, to)
  end
end