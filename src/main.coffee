NanoSock = require 'nanosock'
blobUtil = require 'blob-util'

connection = NanoSock(
  url: "ws://127.0.0.1:3333/mysock"
  protocol: "pub"
)
connection.on 'open', ->
  console.log '[pub] open'

connection.on 'send', (msg) ->
  console.log '[pub] send', msg

connection.on 'message', (ev) ->
  blobUtil.blobToBinaryString(ev.data).then (bs) ->
    console.log '[pub] recv', bs, new Date()
  connection.close()

connection.on 'close', ->
  console.log '[pub] close'

rep = NanoSock(
  url: "ws://127.0.0.1:3335/rep"
  protocol: "rep"
)

rep.on 'open', ->
  console.log '[rep] open'
  rep.send 'hi server'

# rep.on 'send', (msg) ->
#   console.log '[rep] send', msg

rep.on 'message', (ev) ->
  blobUtil.blobToBinaryString(ev.data).then (bs) ->
    console.log '[rep] recv', bs, new Date()
  # rep.close()

rep.on 'close', ->
  console.log '[rep] close'
