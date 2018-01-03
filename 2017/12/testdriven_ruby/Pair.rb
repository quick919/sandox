class Pair
  attr_accessor :from, :to

  def initialize(from, to)
    @from = from
    @to = to
  end

  def eql?(object)
    pair = object
    return @from == pair.from && @to == pair.to
  end

  def hash
    return 0
  end
end