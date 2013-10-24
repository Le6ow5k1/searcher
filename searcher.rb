require 'debugger'

class Searcher
	@data = []
	FIELDS = {:age => 0, :salary => 1, :height => 2, :weight => 3}
	BOUNDS = {:age => 0..100, :salary => 0..10000000.0, :height => 0..200, :weight => 0..200}

	# Создает хэш индексов по заданным полям
	def add_indexes(data, fields)
		indexes = fields.map {|field| [field, build_index(data, field)]}.flatten
		@indexes = Hash[*indexes]
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

		crit = parse_criteria(criteria)
		# Проходим по условиям в порядке их селективности
		# и последовательно уменьшаем нашу выборку
		crit.inject(data) do |data, criterion|
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

	def search_with_index(data, criteria)
		crit = parse_criteria(criteria)
		# c.each{|field, range| result_ids &= @index.select_from(FIELDS[field], range)}

		first_field = crit.keys[0]
		first_result = select(first_field, crit[first_field])
		crit.delete(first_field)
		indexes = crit.inject(first_result) do |data_ind, criterion|
			data_ind &= select(criterion[0], criterion[1])
		end
		result = []
		for i in indexes do
			result << data[i]
		end
		result
	end

	def select(field, range)
		return [] unless field
    return @indexes[field].keys unless range
    result = []
    for i in @indexes[field]
    	if range === i[0]
    		result += i[1]
    	end
    end
   	result
	end

	# def fetch_from_index(field, range)


end
