require_relative './pair'

class Bank
  attr_accessor :rates

  def initialize
    @rates = Hash.new 
  end

  def reduce(source, to)
    return source.reduce(self, to)
  end

  def add_rate(from, to, rate)
    rates[Pair.new(from, to)] = rate
  end

  def rate(from, to)
    if (from == to)
      return 1
    end
    return rates[Pair.new(from, to)]
  end
end