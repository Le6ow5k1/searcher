require "benchmark"
require_relative "./searcher"
require_relative "./person"

@searcher = Searcher.new

N = 10_000_000
@testData = []

for i in 1..N
  @testData << Person.new
end
@criteria = []
@criteria << Hash[:age => (80..150), :salary => (20000..1000000.0), :height => (120..190), :weight => (0..200)]
@criteria << Hash[:age => 69..100, :salary => 20000.0..80000.0, :height => 150..200, :weight => 110..200]
@criteria << Hash[:age => 89..100, :height => 180..200, :weight => 40..110]
@criteria << Hash[:height => 10..20, :weight => 160..200]
@criteria << Hash[:salary => 80000.0..200000.0]
@criteria.each do |c|
  Benchmark.bmbm do |rep|
    rep.report("load:   ") { @searcher.load(@testData) }
    rep.report("kdtree_search: ") { @searcher.kdtree_search(c.dup) }
    rep.report("selectivity_search: ") { @searcher.selectivity_search(c.dup) }
    rep.report("scan_search: ") { @searcher.scan_search(c.dup) }
  end
end