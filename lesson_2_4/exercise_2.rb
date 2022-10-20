class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Animal
  def speak
    'bark!'
  end
  
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Animal
  def speak
    'meow!'
  end
end

pete = Animal.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

p pete.run
# pete.speak

p kitty.run
p kitty.speak
# kitty.fetch

p dave.speak

p bud.run
p bud.swim