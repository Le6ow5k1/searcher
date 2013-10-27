
class KDTree
	attr_reader :root
	attr_reader :objects

	def initialize(objects, fields)
		@fields = fields
		@root = KDNode.new(fields).parse(objects)
	end

	def find(criteria)
		@objects = []
		query(criteria, @root)
		@objects
	end

	def query(criteria, node)
		return unless node
		field = node.field
		median = node.location.send(field)

		if criteria[field].nil? or (node.left and (median >= criteria[field].begin))
			query(criteria, node.left);
		end
		if criteria[field].nil? or (node.right and (median <= criteria[field].end))
			query(criteria, node.right);
		end

		if criteria.all? {|f, r| r.cover? node.location.send(f)}
			@objects << node.location;
		end
	end

end

class KDNode
	attr_reader :left, :right
	attr_reader :location
	attr_reader :field
	FIELDS = {0 => :age, 1 => :salary, 2 => :height, 3 => :weight}

	def initialize(fields, location=nil, left=nil, right=nil)
		@fields = fields
		@location = location
		@left = left
		@right = right
	end

	def parse(objects, depth = 0)
		field = depth % @fields
		@field = FIELDS[field]

		objects = objects.sort_by{|point| point.send(@field)}
		half = objects.length / 2

		@location = objects[half]
		@left = KDNode.new(@fields).parse(objects[0..half-1], depth+1) unless half < 1
		@right = KDNode.new(@fields).parse(objects[half+1..-1], depth+1) unless half+1 >= objects.length
		self
	end

end