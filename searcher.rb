require 'debugger'

class Searcher
	@data = []
	FIELDS = {:age => 0, :salary => 1, :height => 2, :weight => 3}
	BOUNDS = {:age => 0..100, :salary => 0..10000000.0, :height => 0..200, :weight => 0..200}

	# Создает массив индексов по заданным полям
	def add_indexes(data, fields)
		@indexes = fields.map {|field| build_index(data, field)}
	end

	# Создает индекс по соответствующему полю
	def build_index(data, field)
		index = Hash.new
		data.each_with_index do |obj, i|
			if !index.has_key?(obj.send(field))
				index[obj.send(field)] = []
			end
			index[obj.send(field)] << i
		end
		index
	end

	# Производит разбор и сортировку условий по их селективности
	def parse_criteria(criteria)
    parsed = criteria.map do |field, range|
    	if (!FIELDS.has_key? field) or (range == BOUNDS[field])
    		next
    	end
      if range.is_a? Numeric
        [field, (range..range)]
      else [field, range]
      end
    end.compact.sort_by {|k, v| selectivity(k,v)}.flatten
    Hash[*parsed]
  end

  # Расчитывает селективность определенного условия
  def selectivity(field, range)
  	case field
  	when :age 	 then (range.end - range.begin) / 100.0
		when :salary then (range.end - range.begin) / 1000000.0
		when :height then (range.end - range.begin) / 200.0
		when :weight then (range.end - range.begin) / 200.0
		end
  end

	# Осуществляет поиск объектов, удовлетворяющих условиям
	# @param criteria - хеш условий для поиска, может содержать от 0 до 4 условий:
	# 																														:age (0..100)
	# 																														:salary (0..1000000,0)
	# 																														:height (0..200)
	# 																														:weight (0..200)
	# @return массив объектов, удовлетворяющих условиям
	def search(data, criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		@criteria = parse_criteria(criteria)
		# Проходим по условиям в порядке их селективности
		# и последовательно уменьшаем нашу выборку
		@criteria.inject(data) do |data, criterion|
			data.keep_if{|obj| (criterion[1]===obj.send(criterion[0]))}
		end
	end

	def scan_search(data, criteria)
		result = []
		for i in data do
			if criteria[:age]===i.age and criteria[:salary]===i.salary and criteria[:height]===i.height and criteria[:weight]===i.weight
				result << i
			end
		end
	end

	# def search_with_index(data, criteria)
	# 	@criteria = parse_criteria(criteria)
	# 	@criteria.inject(data) do |data, criterion|
	# 		data.keep_if{|obj| (criterion[1]===obj.send(criterion[0]))}
	# 	end
	# 	c.each{|field, range| result_ids &= @index.select_from(FIELDS[field], range)}
	# end

	# def select(field, )

	# def fetch_from_index(field, range)


end
