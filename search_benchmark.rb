require "benchmark"
require_relative "./searcher"
require_relative "./person"

@searcher = Searcher.new

N = 10_000_000
@testData = []

for i in 1..N
  @testData << Person.new
end
@options = Hash[:age => 50..100, :salary => 0, :height => 0..200, :weight => (100..160)]

# 3.times do
	Benchmark.bmbm do |rep|
	  rep.report("load:   ") { @searcher.load(@testData) }
	  rep.report("search: ") { @searcher.search(@options) }
	end
# end