require File.expand_path("../performance", __FILE__)
require "benchmark"

job = LevenshteinJob.new
job.warm_up

Benchmark.benchmark do |b|
  b.report("Levenshtein (no max)"){ job.run_with_no_max }
  b.report("Levenshtein (max 1) "){ job.run_with_max 1 }
  b.report("Levenshtein (max 2) "){ job.run_with_max 2 }
  b.report("Levenshtein (max 4) "){ job.run_with_max 4 }
  b.report("Levenshtein (max 8) "){ job.run_with_max 8 }
end
