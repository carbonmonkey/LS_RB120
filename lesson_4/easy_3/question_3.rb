class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hissssss!!!"
  end
end

dude = AngryCat.new(7, 'Dude')
jerkface = AngryCat.new(3, 'Jerkface Kitty')

dude.name
dude.age
jerkface.name
jerkface.age