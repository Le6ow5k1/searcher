require "benchmark"
require_relative "./searcher"
require_relative "./person"

@searcher = Searcher.new

N = 10_000_000
@testData = []

for i in 1..N
  @testData << Person.new
end
@criteria = Hash[:age => 99..100, :salary => 1000.0..800000.0, :height => 200, :weight => (1..200)]

Benchmark.bmbm do |rep|
  # rep.report("load:   ") { @searcher.load(@testData) }
  # rep.report("parse_criteria: ") {@searcher.parse_criteria(@criteria)}
  # rep.report("selectivity: ") { @searcher.selectivity(:salary, (0..1000000.0)) }
  # rep.report("keep_if: ") {@testData.keep_if{|i| (80..100)===i.field_value(:age)}}
  # rep.report("scan_search: ") { @searcher.scan_search(@testData.dup, @criteria) }
  # rep.report("search: ") { @searcher.search(@testData.dup, @criteria) }
  rep.report("add_indexes: ") { @searcher.add_indexes(@testData, [:age, :salary, :height, :weight]) }
  rep.report("search_with_index: ") { @searcher.search_with_index(@testData, @criteria) }
end