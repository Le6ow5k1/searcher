
class Searcher
	data = []

	# Загружает объекты и упорядочивает их для более удобного поиска
	def load(objects)

	end

	# Осуществляет поиск объектов, удовлетворяющих условиям
	# @param criteria - хеш условий для поиска,
	# может содержать от 0 до 4 условий:
	# 										:age (0..100)
	# 										:salary (0..1000000,0)
	# 										:height (0..200)
	# 										:weight (0..200)
	# @return массив объектов, удовлетворяющих условиям
	def search(criteria)
		raise Exception.new('Expecting a Hash') unless criteria.is_a? Hash

	end

end