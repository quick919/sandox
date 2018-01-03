class ExpressionInterface
  def plus(addend)
    raise NotImplementedError
  end

  def reduce(bank, to)
    raise NotImplementedError
  end
end