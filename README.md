# NanoSock

Small wrapper around WebSocket to help implement nanomsg protocols (scalable
protocols, or SP).

Depends on WebSocket support in browser.

## Include

Script tag:

    <script src="nanosock.js"></script> // window.NanoSock now available

Browserify & Webpack:

    var NanoSock = require('nanosock');

## Usage

    var sock = NanoSock({url: "ws://sp.endpoint.org:3333", protocol: "sub"})

Listen for key events:

    sock.on('open', function() { console.log('socket opened'); });
    sock.on('send', function(msg) { console.log('message sent: ', msg); });
    sock.on('message', function(e) { console.log('message recv: ', e.data); });
    sock.on('close', function() { console.log('socket closed'); });


## Develop

### Go

You'll need Go to install `mangos` for testing.

    # On a Mac with Homebrew:
    brew install go
    # install dependencies
    make wsdeps
    # install macat
    cd $GOPATH/src/github.com/gdamore/mangos/macat
    go install

### JavaScript

You'll need NodeJS and NPM to build the JS lib.

    # On a Mac with Homebrew:
    brew install node

For easy development use Foreman or Goreman (comes with Heroku Toolbelt). This
will actually start three processes at once:

    foreman start

(Otherwise you can run all the commands from Procfile yourself in separate shells.)

Open `http://127.0.0.1:3334` in browser, look at the JavaScript console and
you'll see messages being received from a PUB socket being run by `macat`.

### Build production JS assets

To build production assets:

    make prod

JS libs will then be in `dist` folder.

Certain dependencies like underscore are vendored in the library itself until I
can figure out how not to do that.

