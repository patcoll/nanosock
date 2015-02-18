Socket = require './socket'

connection = Socket("ws://127.0.0.1:3333/echo")
connection.on 'open', ->
  console.log 'open'
  connection.send 'hi'

connection.on 'send', (msg) ->
  console.log 'send', msg

connection.on 'message', (ev) ->
  console.log 'recv', ev.data
  connection.close()

connection.on 'close', ->
  console.log 'close'

