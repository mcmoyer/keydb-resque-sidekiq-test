require './redii'

class KeyDbTestQueueWorker
  @queue = 'keydb_test'
  def self.perform(id)
    Redii.randomize_resque
    File.write("log.txt", "KeyDbTestQueueWorker Received job: #{id}\n", mode: "a")
  end
end

