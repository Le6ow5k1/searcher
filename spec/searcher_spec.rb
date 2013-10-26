require 'rspec'
require_relative '../person'
require_relative '../searcher'

describe Searcher do

	before :each do
		@p1 = Person.new(10,  0, 	 		 150, 100)
		@p2 = Person.new(15,  2000,    180, 150)
		@p3 = Person.new(50,  100,     150, 200)
		@p4 = Person.new(30,  100000,  200, 170)
		@p5 = Person.new(100, 1000000, 100, 0)
		@p6 = Person.new(0, 	 0,      0,   0)
		@people = [@p1, @p2, @p3, @p4, @p5, @p6]
	end

  describe 'search' do
  	context 'when all 4 criteria given' do
		  it 'should find all documents that satisfy given criteria' do
		  	searcher = Searcher.new
		  	searcher.load(@people)
		  	criteria = Hash[:age => (0..50), :salary => (100..1000000.0), :height => (170..200), :weight => 150]
		  	searcher.search(criteria).should be == [@p2]
		  end
		end
		context 'when only a few criteria given' do
		  it 'should find all documents that satisfy given criteria' do
		  	searcher = Searcher.new
		  	searcher.load(@people)
		  	criteria = Hash[:height => (110..200), :weight => (140..200)]
		  	searcher.search(criteria).should be == [@p2, @p3, @p4]
		  end
		end
	end

	describe 'selectivity' do
		it 'computes selectivity of the given range' do
			searcher = Searcher.new
			searcher.selectivity(:height, (100..200)).should be == 0.5
		end
	end

	describe 'parse_criteria' do
		it 'sorts criteria by selectivity' do
			searcher = Searcher.new
			criteria = Hash[:age => 5, :salary => (100..1000000.0), :height => (100..200), :weight => (149..150)]
			result = searcher.parse_criteria(criteria)
			result.should be == {:age => (5..5), :weight => (149..150), :height => (100..200), :salary => (100..1000000.0)}
		end
		context 'when bounds of some criterion is equal to the search bounds' do
			it 'it deletes this criterion' do
				searcher = Searcher.new
				criteria = Hash[:age => 5, :salary => (100..1000000.0), :height => (0..200), :weight => 150]
				result = searcher.parse_criteria(criteria)
				result.should_not have_key(:height)
				result.size.should be == 3
			end
		end
		context 'when some criterion is a Number' do
			it 'it converts it to a range' do
				searcher = Searcher.new
				criteria = Hash[:age => 5, :height => (0..200), :weight => 150]
				result = searcher.parse_criteria(criteria)
				result[:age].should be == (5..5)
				result[:weight].should be == (150..150)
			end
		end
	end

	describe 'scan_search' do
		it 'returns objects that satisfy given criteria' do
			searcher = Searcher.new
			searcher.load(@people)
			criteria = Hash[:age => (0..150), :salary => (0..1000000.0), :height => (0..100), :weight => (0..90)]
	  	searcher.scan_search(criteria).should be == [@p5, @p6]
	  end
	end

	describe 'kdtree_search' do
		it 'returns objects that satisfy given criteria' do
			searcher = Searcher.new
			searcher.load(@people)
			criteria = Hash[:age => (0..150), :salary => (2000..1000000.0), :height => (100..190), :weight => (0..200)]
	  	searcher.scan_search(criteria).should be == [@p2, @p5]
	  end
	end

	# describe 'search_with_index' do
	# 	it 'returns objects that satisfy given criteria' do
	# 		searcher = Searcher.new
	# 		searcher.load(@people)
	# 		criteria = Hash[:age => (0..50), :salary => (100.0..1000000.0), :height => (0..200), :weight => (90..190)]
	#   	searcher.search_with_index(criteria).should be == [@p2, @p4]
	#   end
	# end

	# describe 'build_index' do
	# 	it 'return index hash for given field' do
	# 		searcher = Searcher.new
	# 		searcher.load(@people)
	# 		searcher.build_index(:height).should be == {0 => [5], 100 => [4], 200 => [3], 150 => [0,2], 180 => [1]}
	# 	end
	# end

	# describe 'retrieve_from_index' do
	# 	it 'returns all obj with field values that are in given range' do
	# 		searcher = Searcher.new
	# 		searcher.load(@people)
	# 		searcher.retrieve_from_index(:age, 5..15).should be == [@p1, @p2]
	# 	end
	# end

end