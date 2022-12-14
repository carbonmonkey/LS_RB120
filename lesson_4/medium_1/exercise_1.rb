class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right because the `attr_reader` on line 2 creates a getter method for the `@balance`
# instance variable.


