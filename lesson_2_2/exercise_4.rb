class Person
  attr_accessor :first_name, :last_name
  def initialize(full_name)
    set_full_name(full_name)
  end

  def name=(full_name)
    set_full_name(full_name)
  end

  def name
    (first_name + ' ' + last_name).strip 
  end

  private

  def set_full_name(full_name)
    names = full_name.split
    self.first_name = names.first
    if names.size > 1
      self.last_name = names.last
    else
      self.last_name = ''
    end
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name