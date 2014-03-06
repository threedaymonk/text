require File.expand_path("../performance", __FILE__)
require "benchmark"

job = LevenshteinJob.new
job.run(100)

Benchmark.benchmark do |b|
  b.report("Levenshtein"){ job.run }
end
