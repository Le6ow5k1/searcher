
class Person
	attr_accessor :age, :salary, :height, :weight

	def initialize age=rand(0..100), salary=rand(0..1000000.0), height=rand(0..200), weight=rand(0..200)
		@age = age
		@salary = salary
		@height = height
		@weight = weight
	end

	def field_value(field)
		case field
		when :age 	 then self.age
		when :salary then self.salary
		when :height then self.height
		when :weight then self.weight
		end
	end

end
