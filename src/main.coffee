NanoSock = require 'nanosock'
blobUtil = require 'blob-util'

connection = NanoSock(
  url: "ws://127.0.0.1:3333/mysock"
  protocol: "pub"
)
connection.on 'open', ->
  console.log 'open'

connection.on 'send', (msg) ->
  console.log 'send', msg

connection.on 'message', (ev) ->
  blobUtil.blobToBinaryString(ev.data).then (bs) ->
    console.log 'recv', bs, new Date()
  # connection.close()

connection.on 'close', ->
  console.log 'close'

