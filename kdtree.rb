require 'pp'


FIELDS = {0 => :age, 1 => :salary, 2 => :height, 3 => :weight}

class KDTree
	attr_reader :root
	attr_reader :points

	def initialize(points, dim)
		@dim = dim
		@root = KDNode.new(dim).parse(points)
	end

	# def add_node(point)
	# 	@root.add(point)
	# end

	def find(*range)
		@points = []
		query(range, @root)
		@points
	end

	def query(range, node)
		axis = node.axis
		axis_id = FIELDS.key(axis)
		median = node.location.send(axis)

		if node.left && (median >= range[axis_id].begin)
			query(range, node.left);
		end
		if node.right && (median <= range[axis_id].end)
			query(range, node.right);
		end
		if (0..@dim-1).all? do |ax|
				range[ax].cover? node.location.send(FIELDS[ax])
			end
			@points << node.location;
		end
	end

	def print
		@root.print
	end
end

class KDNode
	attr_reader :left, :right
	attr_reader :location
	attr_reader :axis

	def initialize(dim, location=nil, left=nil, right=nil)
		@dim = dim
		@location = location
		@left = left
		@right = right
	end

	def parse(points, depth = 0)
		axis = depth % @dim
		@axis = FIELDS[axis]

		points = points.sort_by{|point| point.send(@axis)}
		half = points.length / 2

		@location = points[half]
		@left = KDNode.new(@dim).parse(points[0..half-1], depth+1) unless half < 1
		@right = KDNode.new(@dim).parse(points[half+1..-1], depth+1) unless half+1 >= points.length
		self
	end

	# def add(point)
	# 	if @location[@axis] < point[@axis]
	# 		@left ? @left.add(point) : @left = KDNode.new(point)
	# 	else
	# 		@right ? @right.add(point) : @right = KDNode.new(point)
	# 	end
	# end

	# def remove
	# 	self.parse(@left.to_a + @right.to_a, @axis)
	# end

	def to_a
		@left.to_a + [@location] + @right.to_a
	end

	def print(l=0)
		@left.print(l+1) if @left
		puts(" "*l + @location.inspect)
		@right.print(l+1) if @right
	end
end

# a = []
 
# 2.times do |x|
# 	2.times do |y|
# 		4.times do |z|
# 			3.times do |q|
# 				a << [x, y, z, q]
# 			end
# 		end
# 	end
# end
 
# tree = KDTree.new(a, 4)
# tree.print
 
# puts " -------------- "
 
# points = tree.find((0..1), (1..1), (2..4), (0..1))
 
# pp tree.points.sort_by{|po| po[0]}