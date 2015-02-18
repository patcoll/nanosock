# Q = require 'q'
_ = require 'underscore'
Backbone = require 'backbone'

Socket = (options) ->
  unless @ instanceof Socket
    return new Socket options
  @options = _.extend({}, _.result(@, 'options'), options)
  @initialize.apply(@, arguments)

Socket.extend = Backbone.Model.extend

_.extend(Socket.prototype, Backbone.Events,
  initialize: (options) ->
    if arguments.length is 1 and typeof arguments[0] is 'string'
      options = { url: options }

    unless WebSocket
      throw new Error "no WebSocket! please use a browser that has WebSocket support."

    @socket = new WebSocket options.url

    # @deferreds = {}
    _.each [
      'open'
      'close'
      'message'
      'error'
    ], (name) =>
      # @deferreds[name] = Q.defer()
      eventName = "on#{name}"
      @socket[eventName] = =>
        # @deferreds[name]?.resolve(arguments)
        if _.contains(['message', 'error'], name)
          @trigger name, arguments[0]
        else
          @trigger name

    # @waitFor = (name) =>
    #   @deferreds[name]?.promise

    @send = (msg) =>
      @socket.send.apply(@socket, arguments)
      @trigger 'send', msg

    @close = =>
      @socket.close.apply(@socket, arguments)

    # event handlers

    window && window.addEventListener 'beforeunload', => @socket.close()
)

module.exports = Socket
