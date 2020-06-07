require 'resque/tasks'

task "resque:setup" do
  require 'resque'
  require './resque_worker'
  require './redii'
  Resque.logger = Logger.new(STDOUT)
  Redii.randomize_resque
end
