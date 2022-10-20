class Greeting
  def greet(message)
    puts message
  end

  def self.hi
    self.new.greet("Hello from class Greeting")
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end

  # def self.hi
  #   puts("Hello")
  # end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi

