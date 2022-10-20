class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# hello = Hello.new
# hello.hi # outputs 'Hello'

# hello.bye # NoMethodError 

# hello.greet # ArgumentError

# hello.greet("Goodbye") # outputs 'Goodbye'

Hello.hi # NoMethodError

