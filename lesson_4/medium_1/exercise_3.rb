class InvoiceEntry
  attr_reader :product_name
  attr_accessor :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end
end

invoice = InvoiceEntry.new('smurf juice', 2)
p invoice.quantity
invoice.update_quantity(-2)
p invoice.quantity

# The problem is you don't want to create a setter method for `@product_name`
# You also might not want to allow users to circumvent the `update_quantity` method