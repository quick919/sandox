require 'test/unit'
require_relative './dollar'

class MoneyTest < Test::Unit::TestCase
  def test_multiplication
    five = Dollar.new(5)
    product = five.times(2)
    assert_equal 10, product.amount
    product = five.times(3)
    assert_equal 15, product.amount
  end

  def test_equals
    assert_true Dollar.new(5).equal?(Dollar.new(5))
    assert_false Dollar.new(5).equal?(Dollar.new(6))
  end
end