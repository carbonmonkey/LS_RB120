module Speed
  def go_fast
    puts "I am a #{Car::CLASS} and going super fast!"
  end
end

class Car
  include Speed
  CLASS = 'car'
  def get_class
    self.class
  end
  def go_slow
    puts "I am a #{CLASS}, safe and driving slow."
  end
end

small_car = Car.new
small_car.go_fast
small_car.go_slow
p Car.to_s
# The Object#class method is invoked on `self`, which represents the `Car` object
# which the `go_fast` method was invoked on. 

# The `class` method returns `Car`, the class of the object it was invoked on.