class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable, which is scoped to the `Cat` class. When a new instance of `Cat` is created, `@@cats_count`
# is incremented by 1.

p Cat.cats_count
Cat.new('a')
Cat.new('b')
p Cat.cats_count