Consumer = require('sqs-consumer')

class Worker

  consumers: []

  constructor: (@options, fn)->
    for i in [0...@options.concurrency]
      consumer = Consumer.create({
        queueUrl: @options.QueueUrl,
        sqs: @options.sqs,
        handleMessage: (message, done)->
          fn(JSON.parse(message.Body), done)
      })
      @consumers.push(consumer)

    @start()

  start: ()->
    for consumer in @consumers
     consumer.start()

  stop: ()->
    for consumer in @consumers
      consumer.stop()

module.exports = Worker