class ExpressionInterface

  def times(multiplier)
    raise NotImplementedError
  end
  
  def plus(addend)
    raise NotImplementedError
  end

  def reduce(bank, to)
    raise NotImplementedError
  end
end