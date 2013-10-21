require 'rspec'
require_relative '../person'
require_relative '../searcher'

describe Searcher do

	before :all do
		@p1 = Person.new(10,  0, 	 		150, 100)
		@p2 = Person.new(15,  2000,    180, 150)
		@p3 = Person.new(50,  100,     150, 200)
		@p4 = Person.new(30,  100000,  200, 170)
		@p5 = Person.new(100, 1000000, 100, 0)
		@p6 = Person.new(0, 	 0,       0,   0)
		@people = [@p1, @p2, @p3, @p4, @p5, @p6]
	end

  describe 'search' do
  	context 'when all 4 criteria given' do
		  it 'should find all documents that satisfy given criteria' do
		  	@searcher = Searcher.new
		  	@searcher.load(@people)
		  	options = Hash[:age => (0..50), :salary => (100..1000000), :height => (170..200), :weight => 150]
		  	@searcher.search(options).should be == [@p2]
		  end
		end
		context 'when only a few criteria given' do
		  it 'should find all documents that satisfy given criteria' do
		  	@searcher = Searcher.new
		  	@searcher.load(@people)
		  	options = Hash[:height => (110..200), :weight => (140..200)]
		  	@searcher.search(options).should be == [@p2, @p3, @p4]
		  end
		end
	end

end