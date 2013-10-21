
class Searcher
	@data = []

	# Загружает объекты и упорядочивает их для более удобного поиска
	def load(objects)
		@data = objects
		# build_index_age
		# build_index_salary
	end

	# Создает индекс по соответствующему полю
	def build_index_age
		@age_hash = Hash.new
		@data.each_with_index do |obj, i|
			if !@age_hash.has_key?(obj.age)
				@age_hash[obj.age] = []
			end
			@age_hash[obj.age] << i
		end
	end

	# def build_index_salary
	# 	@salary_hash = Hash.new
	# 	@data.each_with_index do |obj, i|
	# 		if !@salary_hash.has_key?(obj.salary)
	# 			@salary_hash[obj.salary] = []
	# 		end
	# 		@salary_hash[obj.salary] << i
	# 	end
	# end

	# Осуществляет поиск объектов, удовлетворяющих условиям
	# @param criteria - хеш условий для поиска, может содержать от 0 до 4 условий:
	# 																														:age (0..100)
	# 																														:salary (0..1000000,0)
	# 																														:height (0..200)
	# 																														:weight (0..200)
	# @return массив объектов, удовлетворяющих условиям
	def search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		age_range 	 = criteria[:age] 	 unless criteria[:age].nil?
		salary_range = criteria[:salary] unless criteria[:salary].nil?
		height_range = criteria[:height] unless criteria[:height].nil?
		weight_range = criteria[:weight] unless criteria[:weight].nil?



		# sel_age 	 = (criteria[:age].end - criteria[:age].begin) / 100
		# sel_salary = (criteria[:salary].end - criteria[:salary].begin) / 1000000
		# sel_height = (criteria[:height].end - criteria[:height].begin) / 200
		# sel_weight = (criteria[:weight].end - criteria[:weight].begin) / 200



		# selected_age = @age_hash.select {|k, v| age_range === k}.values.flatten
		# for i in selected_age
		# 	@salary_hash.select
		# @new_data = []
		# for i in selected_age
		# 	@new_data << @data[i]
		# end

		# result = []
		one = @data.select {|i| age_range===i.age}
		two = one.select {|i| salary_range===i.salary}
		three = two.select {|i| height_range===i.height}
		three.select {|i| weight_range===i.weight}
		# for i in @new_data do
		# 	if salary_range === i.salary and height_range === i.height and weight_range === i.weight
		# 		result << i
		# 	end
		# end

	end

	def test_predicate(obj, criteria)

	end

	# def predicate(obj, criteria)
	# 	sel_salary = (criteria[:salary].end - criteria[:salary].begin) / 1000000
	# 	sel_height = (criteria[:height].end - criteria[:height].begin) / 200
	# 	sel_weight = (criteria[:weight].end - criteria[:weight].begin) / 200

	# 	if sel_salary < sel_height < sel_weight
	# 		if criteria[:salary].cover? obj.salary and criteria[:height].cover? obj.height and criteria[:weight].cover? obj.weight
	# 			return true
	# 		end
	# 	elsif sel_height < sel_weight < sel_salary
	# 		if criteria[:height].cover? obj.height and criteria[:weight].cover? obj.weight and criteria[:salary].cover? obj.salary
	# 		  return true
	# 		end
	# 	else
	# 		if criteria[:weight].cover? obj.weight and criteria[:height].cover? obj.height and criteria[:salary].cover? obj.salary
	# 			return true
	# 		end
	# 	end

end
