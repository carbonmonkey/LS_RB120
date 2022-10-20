class Television
  def self.manufacturer

  end

  def model

  end
end

tv = Television.new
# tv.manufacturer # NoMethodError
tv.model # `model` instance method called on `Television` object

Television.manufacturer # `manufacturer` class method called on `Television` class.
Television.model # NoMethodError

