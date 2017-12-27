require 'test/unit'
require_relative './dollar'

class MoneyTest < Test::Unit::TestCase
  def test_multiplication
    five = Dollar.new(5)
    five.times(2)
    assert_equal 10, five.amount
  end
end