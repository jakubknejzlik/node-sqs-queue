# node-sqs-queue

[![Build Status](https://travis-ci.org/jakubknejzlik/node-sqs-queue.svg?branch=master)](https://travis-ci.org/jakubknejzlik/node-sqs-queue)

# Installation

`npm install --save sqs-queue`

# Example

```coffeescript
SQSQueue = require('sqs-queue')

queue = new SQSQueue({
    QueueUrl: process.env.QUEUE_URL,
    accessKeyId: process.env.ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY
})

worker = queue.createWorker((message,done)->
    console.log('received message', message.foo, message.blah)
    done()
,{concurrency: 1})
# you can additionally stop worker by calling worker.stop()

queue.push({foo: 'foo value', blah: 'blah value'}).then(()->
    console.log('item pushed')
).catch((err)->
    console.error('something bad happened:',err.message)
)
```