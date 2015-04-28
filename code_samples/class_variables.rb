# Demo about usage of class variables

class SedanCar
  @@wheel_count = 4

  class << self
    def wheel_count
      @@wheel_count
    end

     def wheel_count=(number_of_wheels)
      # Ideally there must be a lock mechanism to prevent other instances 
      # from accessing @@wheel_count at the same time.
      @@wheel_count = number_of_wheels
    end
  end  

  # Instance method that changes value of class variable
  # One instance change number_of_wheels, all other instances will see the change
  def class_wheel_count=(number_of_wheels)
    
    # Ideally there must be a lock mechanism to prevent other instances 
    # from accessing @@wheel_count at the same time.
    @@wheel_count = number_of_wheels
  end

  def class_wheel_count
    @@wheel_count
  end
end

# Read class variable via class
puts "A sedan car has #{SedanCar.wheel_count} wheels."

# Read class variable from object instance 
a_ford  = SedanCar.new
a_honda = SedanCar.new

puts "A Ford sedan has #{a_ford.class_wheel_count} wheels.\nA Honda sedan has #{a_honda.class_wheel_count} wheels.\n"

# Set value of class variable via class
SedanCar.wheel_count = 5

# Now, all the instances see the same changed value:
puts "\nAfter changing wheel_count via class:\nA Ford sedan has #{a_ford.class_wheel_count} wheels.\nA Honda sedan has #{a_honda.class_wheel_count} wheels.\n"

# One instance changes the class variable, all other instances will see the change:
a_ford.class_wheel_count = 3

puts "\nAfter one instance changed wheel_count:\nA sedan car has #{SedanCar.wheel_count} wheels."
puts "A Ford sedan has #{a_ford.class_wheel_count} wheels.\nA Honda sedan has #{a_honda.class_wheel_count} wheels.\n"



