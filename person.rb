
class Person
	attr_accessor :age, :salary, :height, :weight
	BOUNDS = {:age => 0..100, :salary => 0..1000000.0, :height => 0..200, :weight => 0..200}

	def initialize age=rand(0..100), salary=rand(0..1000000.0), height=rand(0..200), weight=rand(0..200)
		raise Exception.new('param value is out of range') unless BOUNDS[:age].cover? age and
		BOUNDS[:salary].cover? salary and BOUNDS[:height].cover? height and BOUNDS[:weight].cover? weight

		@age = age
		@salary = salary
		@height = height
		@weight = weight
	end

end
