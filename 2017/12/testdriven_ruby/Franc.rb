class Franc < Money
  def initialize(amount, currency)
    super
  end

  def times(multiplier)
    return Money.franc(@amount * multiplier)
  end
end