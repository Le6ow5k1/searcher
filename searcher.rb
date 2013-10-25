require 'debugger'

class Searcher
	@data = []
	BOUNDS = {:age => 0..100, :salary => 0..1000000.0, :height => 0..200, :weight => 0..200}

	def load(data)
		@data = data
		# add_indexes([:age, :height, :weight, :salary])
	end

	# Создает хэш индексов по заданным полям
	def add_indexes(fields)
		indexes = fields.map {|field| [field, build_index(field)]}.flatten
		@indexes = Hash[*indexes]
	end

	# Создает индекс по соответствующему полю
	def build_index(field)
		index = Hash.new
		@data.each_with_index do |obj, i|
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
    	if range == BOUNDS[field]
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
	def search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)
		# Проходим по условиям в порядке их селективности
		# и последовательно уменьшаем нашу выборку
		crit.inject(@data.dup) do |data, criterion|
			data.keep_if{|obj| (criterion[1]===obj.send(criterion[0]))}
		end
	end

	# Поиск с простым проходом по всем объектам
	def scan_search(criteria)
		crit = parse_criteria(criteria)
		result = []
		for i in @data do
			if crit.all? {|field, range| range === i.send(field)}
				result << i
			end
		end
		result
	end

	def search_with_index(criteria)
		crit = parse_criteria(criteria)
		first_field = crit.keys[0]
		first_result = select_from_index(first_field, crit[first_field])
		crit.delete(first_field)
		crit.each_pair do |f, r|
			first_result &= select_from_index(f, r)
		end
		result = []
		for i in first_result do
			result << @data[i]
		end
		result
	end

	def select_from_index(field, range)
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


end
