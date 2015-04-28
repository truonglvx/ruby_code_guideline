# Demo about bad use and good use of instance variables

# Bad usage: Use instance variable to communicate between methods
class Van
  # Assume that a van loses 10% of the original price every year
  ANNUAL_PERCENTAGE_LOST = 10

  attr_accessor :year, :original_price
  def initialize(a_year, an_original_price)
    @year = a_year
    @original_price = an_original_price
  end

  def value_of_the_year(the_year)
    # The instance variable @current_year is used to communicate the value of year 
    # between the methof value_now() and the method lost_value()
    @current_year = the_year
    original_price - lost_value
  end

  def lost_value
    (@current_year - year) * (original_price * ANNUAL_PERCENTAGE_LOST/100)
  end
end

a_sienna = Van.new(2010, 30000)
puts "Value of the Sienna now is #{a_sienna.value_of_the_year(2015)}"


# Good usage
class Truck
  # Assume that a truck also loses 10% of the original price every year
  ANNUAL_PERCENTAGE_LOST = 10

  attr_accessor :year, :original_price
  def initialize(a_year, an_original_price)
    @year = a_year
    @original_price = an_original_price
  end

  def value_of_the_year(the_year)
    # Pass the value we want to communicate as parameter
    original_price - lost_value(the_year)
  end

  def lost_value(the_year)
    (the_year - year) * (original_price * ANNUAL_PERCENTAGE_LOST/100)
  end
end

a_tundra = Truck.new(2010, 30000)
puts "Value of the Tundra now is #{a_tundra.value_of_the_year(2015)}"

puts("\n\nAlthoght you see the calculations are the same for a van and a truck, there is a major problem with the class Van:")
puts("Current year is not an attribute of a van, and should not be an instance variable of the class Van.")



