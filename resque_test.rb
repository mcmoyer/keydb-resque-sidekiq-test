require 'bundler'
Bundler.require

require './resque_worker'
require './redii'
QUEUE = 'keydb_test'

class EnqueueJob
  class << self
    def call(num_jobs: 3000)
      failures = []

      num_jobs.times do |i|
        Redii.randomize_resque
        unless Resque.enqueue(KeyDbTestQueueWorker, i)
          failures.push(i)
        end
      end
      { num_jobs: num_jobs, failures: failures }
    end
  end
end

Redis.new(Redii.random).flushall()
File.delete("log.txt") if File.exist?("log.txt")
puts EnqueueJob.call

puts Resque.info

# ruby ./resque_test.rb
# QUEUE=keydb_test bundle exec rake resque:workers COUNT=6
# wc -l log.txt && sort -u log.txt | wc -l

