assert = require('assert')
SQSQueue = require('../index')

queue = new SQSQueue({
  QueueUrl: 'https://sqs.eu-central-1.amazonaws.com/458470902217/sqs-queue-test',
  accessKeyId: "AKIAJBR4RCFU5DMYFQFQ",
  secretAccessKey: "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"
})

describe('test',()->
#  before(()->
#    return queue.purge()
#  )

  it('should push and retreive data from queue',(done)->
    value = Math.random()
    queue.createWorker((message,_done)->
      assert.equal(message.value,value)
      _done()
      done()
    )
    queue.push({value: value}).catch(done)
  )
)