require 'bundler'
Bundler.require

require './sidekiq_worker'
require './redii'
require 'sidekiq/api'

QUEUE = 'keydb_test'

Redii.randomize_sidekiq

class EnqueueJob
  class << self
    def call(num_jobs: 3000)
      num_jobs.times do |i|
        Redii.randomize_sidekiq
        KeyDbSidekiqTestQueueWorker.perform_async(i)
      end
    end
  end
end

Redis.new(Redii.random).flushall()
File.delete("log.txt") if File.exist?("log.txt")
EnqueueJob.call

puts Sidekiq::Stats.new.inspect

# ruby ./sidekiq_test.rb
# bundle exec sidekiq -c 10 -r ./sidekiq_worker.rb - when finished hit ctrl-c to exit
# wc -l log.txt && sort -u log.txt | wc -l
