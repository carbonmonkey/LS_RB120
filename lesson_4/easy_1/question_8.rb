class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# `self` refers to the object that `make_one_year_older` is invoked on.