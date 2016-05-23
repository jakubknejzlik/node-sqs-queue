AWS = require('aws-sdk')
url = require('url')

Worker = require('./Worker')

class Queue
  constructor: (@options)->
    @sqs = new AWS.SQS({
      accessKeyId: @options.accessKeyId,
      secretAccessKey: @options.secretAccessKey,
      region: @options.region or @_getRegionFromQueueUrl(@options.QueueUrl)
    })

  push: (data, state = 'default')->
    return new Promise((resolve, reject)=>
      params = {MessageAttributes: {}}
      params.MessageBody = JSON.stringify(data)
      params.QueueUrl = @options.QueueUrl
      params.DelaySeconds = params.DelaySeconds or 0
      @sqs.sendMessage(params, (err, data)->
        return reject(err, err.stack) if err
        resolve(data)
      )
    )

  purge: ()->
    return new Promise((resolve, reject)=>
      @sqs.purgeQueue({QueueUrl: @options.QueueUrl},(err, data)->
        return reject(err) if err
        resolve(data)
      )
    )

  createWorker: (fn,options = {})->
    options = Object.create(@options)
    options.sqs = @sqs
    options.concurrency = options.concurrency or 1
    return new Worker(options,fn)

  _getRegionFromQueueUrl: (queueUrl)->
    hostname = url.parse(queueUrl).hostname
    return hostname.replace(/sqs.([^\.]+).amazonaws.com/,'$1')


module.exports = Queue