.PHONY: default all ws wsdeps prod watch start run clean contributors
WFLAGS=--colors
WEBPACK=./node_modules/.bin/webpack

# javascript

default: all

all: deps
	$(WEBPACK) $(WFLAGS)

prod: deps
	NODE_ENV=production $(WEBPACK) $(WFLAGS)

watch: deps
	$(WEBPACK) $(WFLAGS) --watch

deps:
	[[ -f bower.json ]] && bower install || true
	[[ -f package.json ]] && npm install || true

start:
	foreman start

run: watch

# golang

wsrun: ws
	exec ./nanosock

ws: wsdeps
	go build

wsdeps:
	go get -u github.com/gdamore/mangos
	go get -u golang.org/x/net/websocket

# helpers

clean:
	rm -rf build dist ./nanosock

contributors:
	echo "Contributors to nanosock, both large and small:\n" > CONTRIBUTORS
	git log --raw | grep "^Author: " | sort | uniq | cut -d ' ' -f2- | sed 's/^/- /' | cut -d '<' -f1 >> CONTRIBUTORS
