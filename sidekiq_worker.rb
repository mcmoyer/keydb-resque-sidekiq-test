require './redii'

Redii.randomize_sidekiq

class KeyDbSidekiqTestQueueWorker
  include Sidekiq::Worker

  @queue = 'keydb_test'
  def perform(id)
    Redii.randomize_sidekiq
    File.write("log.txt", "KeyDbTestQueueWorker Received job: #{id}\n", mode: "a")
  end
end

