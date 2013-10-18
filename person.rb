
class Person
	attr_accessor :age, :salary, :height, :weight

	def initialize(age, salary, height, weight)
		@age = age			 || random(0..100)
		@salary = salary || random(0..1000000)
		@height = height || random(0..200)
		@weight = weight || random(0..200)
	end

end
