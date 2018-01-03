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
    return nil
  end
end