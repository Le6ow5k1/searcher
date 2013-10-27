require 'debugger'
require './kdtree'

class Searcher
	@data = []
	BOUNDS = {:age => 0..100, :salary => 0..1000000.0, :height => 0..200, :weight => 0..200}

	def load(data)
		@data = data
		# add_indexes([:age, :height, :weight])
		@kdtree = KDTree.new(@data.dup, 4) unless @kdtree
	end

	# Создает хэш индексов по заданным полям
	def add_indexes(fields)
		indexes = fields.flat_map {|field| [field, build_index(field)]}
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
    	next if range == BOUNDS[field]
      if range.is_a? Numeric
        [field, (range..range)]
      else
      	[field, range]
      end
    end.compact.sort_by {|k, v| selectivity(k,v)}.flatten
    Hash[*parsed]
  end

  # Расчитывает селективность определенного условия
  def selectivity(field, range)
  	diff = if (range.end - range.begin) != 0
  		(range.end - range.begin)
  	else
  		0.01
  	end

  	case field
  	when :age 	 then diff / 100.0
		when :salary then diff / 1000000.0
		when :height then diff / 200.0
		when :weight then diff / 200.0
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
			break if data.empty?
			data.keep_if{|obj| (criterion[1] === obj.send(criterion[0]))}
		end
	end

	# Поиск с простым проходом по всем объектам
	def scan_search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)

		@data.select do |obj|
			crit.all? {|field, range| range.cover? obj.send(field)}
		end
	end

	def kdtree_search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		# crit = criteria.map do |field, range|
		# 	if range.is_a? Numeric; (range..range)
		# 	elsif range == BOUNDS[field]; nil
		# 	else range
		# 	end
		# end
		crit = parse_criteria(criteria)

		@kdtree.find(crit)
	end

	def search_with_index(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)
		return scan_search(crit) if crit.size == 1 and crit[:salary]
		salary = crit.delete(:salary)
		first_field = crit.keys[0]
		acc = select_from_index(first_field, crit[first_field])
		return @data.values_at(*acc) if crit.size == 1
		crit.delete(first_field)
		crit.each do |f, r|
			acc &= select_from_index(f, r)
		end
		result = []
		for i in acc do
			if salary.cover? @data[i].salary
			result << @data[i]
		end
		end
		result
	end

	def retrieve_from_index(field, range)
    result = []
    for i in @indexes[field]
    	if range === i[0]
    		result += @data.values_at(*i[1])
    	end
    end
   	result
	end

	def select_from_index(field, range)
    result = []
    for i in @indexes[field]
    	if range === i[0]
    		result += i[1]
    	end
    end
   	result
	end

	# def qsort_by!(data, field, l = 0, r = data.size - 1)
 #    i, j = l, r
 #    base_point = data[((l + r) / 2).to_i].send(field)
 #    loop do
 #      i += 1 while data[i].send(field) < base_point
 #      j -= 1 while data[j].send(field) > base_point

 #      if i <= j
 #        data[i], data[j] = data[j], data[i]
 #        i += 1
 #        j -= 1
 #      else
 #        break
 #      end
 #    end

 #    qsort_by!(data, field, l, j) if j > l
 #    qsort_by!(data, field, i, r) if i < r
 #    data
 #  end

end
