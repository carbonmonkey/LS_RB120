module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truch and like going very slow."
  end
end


p Car.ancestors, Truck.ancestors

Car.new.go_fast
Truck.new.go_fast