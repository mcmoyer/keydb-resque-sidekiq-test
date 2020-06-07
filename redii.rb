REDI = [
  {namespace: 'myapp', size: 25, url: 'redis://keydb1:6379/0' },
  {namespace: 'myapp', size: 25, url: 'redis://keydb2:6379/0' }
]

class Redii
  class << self
    def random
      REDI.sample
    end

    def randomize_sidekiq
      redis = REDI.sample
      Sidekiq.configure_server {|config| config.redis = redis }
      Sidekiq.configure_client {|config| config.redis = redis }
    end

    def randomize_resque
      redis = Redis.new(REDI.sample)
      Resque.redis = redis
    end
  end
end
