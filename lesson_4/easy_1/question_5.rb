class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
    @age = 'unknown'
  end
end

p Pizza.new('yo').instance_variables
p Fruit.new('yo').instance_variables