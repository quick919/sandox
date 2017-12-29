class Money
  attr_accessor :amount

  def ==(other_money)
    @amount == other_money.amount
  end
end