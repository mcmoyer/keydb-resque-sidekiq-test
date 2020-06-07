# KeyDB Active Replication with Resque/Sidekiq

This is a simple project that demonstrates the issue with trying to use Active Replication from KeyDB and a queueing system like Resque or Sidekiq

The issue boils down to the structure in which the queue is stored.  The jobs are stored in a list structure.  When a job is finished, it will blindly left pop an item off the list.  Since there is some latency in the synchronization of the keys, one worker may hit keydb1 and get its next job.  Meanwhile, that job has just been finshed by another worker that removes the job from keyb2.  Worker #1 finishes it's job and lpops what it thinks is it's job.  Therefore some jobs are run duplicated and some are not run at all.

### Running the tests

```
docker-compose up -d
docker-compose exec ruby bash

cd /keydb-test

## for resque tests
ruby ./resque_test.rb

QUEUE=keydb_test bundle exec rake resque:workers COUNT=6
# when queue is drained, use ctrl-c to exit
  
wc -l log.txt && sort -u log.txt | wc -l

## for sidekiq tests
ruby ./sidekiq_test.rb

bundle exec sidekiq -c 10 -r ./sidekiq_worker.rb - when finished hit ctrl-c to exit
# when queue is drained, use ctrl-c to exit

wc -l log.txt && sort -u log.txt | wc -l
```

You can change `COUNT` on the resque worker to increase or decrease the amount of forks that will start.  Working with `COUNT=1` will process all 3000 jobs correctly as its a single thread and the replication can keep up with the changes.  To change the sidekiq version, change the `-c` flag.