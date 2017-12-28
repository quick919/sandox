require 'test/unit'
require_relative './dollar'

class MoneyTest < Test::Unit::TestCase
  def test_multiplication
    five = Dollar.new(5)
    assert_equal Dollar.new(10),  five.times(2)
    assert_equal Dollar.new(15), five.times(3)
  end

  def test_equals
    assert_true Dollar.new(5) == Dollar.new(5)
    assert_false Dollar.new(5) == Dollar.new(6)
  end
end