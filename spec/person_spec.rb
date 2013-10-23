require 'rspec'
require './person'

describe Person do
 
  context 'with no arguments given' do
	  it 'initialzed with random values' do
	  	@person = Person.new
	  	@person.age.should be_between(0, 100)
	  	@person.salary.should be_between(0, 1000000.0)
	  	@person.height.should be_between(0, 200)
	  	@person.weight.should be_between(0, 200)
	  end
	end
 
  context 'with all arguments given' do
  	it 'initialized with appropriate values' do
  		@person = Person.new(1, 666, 200, 200)
  		@person.age.should be 1
	  	@person.salary.should be 666
	  	@person.height.should be 200
	  	@person.weight.should be 200
	  end

	  context 'when arguments are out of valid ranges' do
	  	it 'should raise an error' do
	  		pending
	  	end
	  end
	  
	end

end