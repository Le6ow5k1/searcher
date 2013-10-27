require 'pp'


FIELDS = {0 => :age, 1 => :salary, 2 => :height, 3 => :weight}

class KDTree
	attr_reader :root
	attr_reader :points

	def initialize(points, fields)
		@fields = fields
		@root = KDNode.new(fields).parse(points)
	end

	# def add_node(point)
	# 	@root.add(point)
	# end

	def find(criteria)
		@points = []
		query(criteria, @root)
		@points
	end

	def query(criteria, node)
		return unless node
		axis = node.axis
		# axis_id = FIELDS.key(axis)
		median = node.location.send(axis)

		if criteria[axis].nil? or (node.left && (median >= criteria[axis].begin))
			query(criteria, node.left);
		end
		if criteria[axis].nil? or (node.right && (median <= criteria[axis].end))
			query(criteria, node.right);
		end

		if criteria.all? {|f, r| r.cover? node.location.send(f)}
			@points << node.location;
		end
	end

	# def print
	# 	@root.print
	# end
end

class KDNode
	attr_reader :left, :right
	attr_reader :location
	attr_reader :axis

	def initialize(fields, location=nil, left=nil, right=nil)
		@fields = fields
		@location = location
		@left = left
		@right = right
	end

	def parse(points, depth = 0)
		axis = depth % @fields
		@axis = FIELDS[axis]

		points = points.sort_by{|point| point.send(@axis)}
		half = points.length / 2

		@location = points[half]
		@left = KDNode.new(@fields).parse(points[0..half-1], depth+1) unless half < 1
		@right = KDNode.new(@fields).parse(points[half+1..-1], depth+1) unless half+1 >= points.length
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

	# def to_a
	# 	@left.to_a + [@location] + @right.to_a
	# end

	# def print(l=0)
	# 	@left.print(l+1) if @left
	# 	puts(" "*l + @location.inspect)
	# 	@right.print(l+1) if @right
	# end
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