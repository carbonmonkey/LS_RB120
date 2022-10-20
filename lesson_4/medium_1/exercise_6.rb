# In the first example, line 5 assigns a string value to the instance variable `@template`

# In the second example, line 5 invokes the setter method `template=`.
  # `template=` assigns its string argument to `@template`

# The difference in syntax with the `show_template` does not affect how the code runs.
  # The setter method `template` is used in both cases to return the value of `@template`

  class Computer
    attr_accessor :template
  
    def create_template
      @template = "template 14231"
    end
  
    def show_template
      template
    end
  end


  class Computer
    attr_accessor :template
  
    def create_template
      self.template = "template 14231"
    end
  
    def show_template
      self.template
    end
  end