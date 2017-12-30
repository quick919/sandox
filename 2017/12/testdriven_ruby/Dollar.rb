require_relative './money'

class Dollar < Money
  def initialize(amount, currency)
    super
  end

  def times(multiplier)
    return Money.dollar(@amount * multiplier)
  end
end