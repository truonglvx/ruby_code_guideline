puts "\nNumber"
def add_two(a_number)
  a_number += 2
end

wheel_count = 4
puts "Before: wheel_count = #{wheel_count}"
puts "Add 2 to wheel_count = #{add_two(wheel_count)}."
puts "After method call, no side effect, wheel_count = #{wheel_count}"


puts "\nString:"
def append_dollar(price)
  price += ' dollars'
end

car_price = '20 K'
puts "Before: car_price = #{car_price}"
puts "Append dollar - car_price = #{append_dollar(car_price)}"
puts "After method call, no side effect, car_price = #{car_price}"


puts "\nObject:"
class Car
  attr_accessor :make
end

def fix_make(car)
  car.make = 'I fix the make'
end

car = Car.new
car.make = 'Ford'
puts "Before: car.make  = #{car.make }"
puts "Change the make - fix_make = #{fix_make(car)}"
puts "After method call, side effect happens, car.make = #{car.make}"


puts "\nObject, avoid side effect using dup:"
class Car
  attr_accessor :make
end

def fix_make(car)
  dup_car = car.dup
  dup_car.make = 'I fix the make'
end

car = Car.new
car.make = 'Ford'
puts "Before: car.make  = #{car.make }"
puts "Change the make - fix_make = #{fix_make(car)}"
puts "After method call, no side effect, car.make = #{car.make}"


