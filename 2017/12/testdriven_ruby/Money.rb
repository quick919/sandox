class Money
  attr_accessor :amount

  def ==(other_money)
    @amount == other_money.amount && self.class.equal?(other_money.class)
  end
end