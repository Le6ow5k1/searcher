require './kdtree'

class Searcher
	@data = []
	BOUNDS = {:age => 0..100, :salary => 0..1000000.0, :height => 0..200, :weight => 0..200}

	def load(data)
		@data = data
		@kdtree = KDTree.new(@data.dup, 4) unless @kdtree
	end

	# Поиск с простым проходом по всем объектам
	def scan_search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)

		@data.select do |obj|
			crit.all? {|field, range| range.cover? obj.send(field)}
		end
	end

	# Алгоритм с последовательным уменьшением области поиска
	def selectivity_search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)

		# Проходим по условиям в порядке их селективности
		# и последовательно уменьшаем нашу выборку
		crit.inject(@data.dup) do |data, criterion|
			break if data.empty?
			data.keep_if{|obj| (criterion[1]===obj.send(criterion[0]))}
		end
	end

	# Алгоритм с использованием в качестве структуры данных К-мерного дерева
	def kdtree_search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

		crit = parse_criteria(criteria)

		@kdtree.find(crit)
	end

	# Производит разбор и сортировку условий по их селективности
	def parse_criteria(criteria)
    parsed = criteria.map do |field, range|
    	next if range == BOUNDS[field]
      if range.is_a? Numeric then [field, (range..range)]
      else [field, range]
      end
    end.compact.sort_by {|k, v| selectivity(k,v)}.flatten

    Hash[*parsed]
  end

  # Расчитывает селективность определенного условия
  def selectivity(field, range)
  	diff = (range.end-range.begin)
		diff = 0.01 if (range.end-range.begin) == 0 # чтобы при делении на ширину
																								# диапазона не получать ноль
  	diff / BOUNDS[field].end.to_f
  end

end
