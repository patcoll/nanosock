_ = require 'underscore'
Events = require 'ampersand-events'
# TODO: research ampersand-object-assign
blobUtil = require 'blob-util'

NanoSock = (options) ->
  unless @ instanceof NanoSock
    return new NanoSock options
  @options = _.extend({}, _.result(@, 'options'), options)
  @initialize.apply(@, arguments)

# Small wrapper around WebSocket to help implement nanomsg protocols (scalable
# protocols, or SP).
#
# Usage:
#
#   sock = NanoSock({url: "ws://sp.endpoint.org:3333", protocol: "sub"})
#
# Listen for key events:
#
#   sock.on('open', function() { console.log('socket opened'); });
#   sock.on('send', function(msg) { console.log('message sent: ', msg); });
#   sock.on('message', function(e) { console.log('message recv: ', e.data); });
#   sock.on('close', function() { console.log('socket closed'); });
#
_.extend(NanoSock.prototype, Events,
  newSocket: ->
    new WebSocket @options.url, "#{@options.protocol}.sp.nanomsg.org"
  sendBehaviors:
    sub: ->
      console.log 'server is sub'
      @socket.send.apply(@socket, arguments)
    rep: ->
      console.log 'server is rep'
      console.log 'send', arguments
      @socket.send.apply(@socket, arguments)
  send: (msg) ->
    unless @sendBehaviors[@options.protocol]?
      throw new Error "#{@options.protocol} protocol not implemented yet"
    @sendBehaviors[@options.protocol]?.apply(@, arguments)
    @trigger 'send', msg
  close: ->
    @socket.close.apply(@socket, arguments)
  options:
    url: null
    protocol: null
    # TODO: add reconnect
    reconnect: false
  initialize: (options) ->
    unless WebSocket
      throw new Error "no WebSocket! please use a browser that has WebSocket support."

    unless @options.url?
      throw new Error "no url! please provide a url."

    unless @options.protocol?
      throw new Error "no protocol! please provide a protocol."

    @header = new Uint32Array(1)
    @socket = @newSocket()

    _.each [
      'open'
      'close'
      'message'
      'error'
    ], (name) =>
      eventName = "on#{name}"
      @socket[eventName] = =>
        if name in ['message', 'error']
          @trigger name, arguments[0]
        else
          @trigger name

    # event handlers

    # convenience to close socket on reload or when browsing away from page.
    window?.addEventListener?('beforeunload', => @socket.close())
)

module.exports = NanoSock
