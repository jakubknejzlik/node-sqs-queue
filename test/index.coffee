assert = require('assert')
SQSQueue = require('../index')

queue = new SQSQueue({
  QueueUrl: process.env.QUEUE_URL,
  accessKeyId: process.env.ACCESS_KEY_ID,
  secretAccessKey: process.env.SECRET_ACCESS_KEY
})

describe('test',()->
#  before(()->
#    return queue.purge()
#  )

  it('should push and retreive data from queue',(done)->
    value = 'hello world'
    queue.createWorker((message,_done)->
      _done()
      assert.equal(message.value,value)
      done()
    )
    queue.push({value: value}).catch(done)
  )
)