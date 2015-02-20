.PHONY: default all ws wsdeps prod watch start run clean contributors
WFLAGS=--colors

default: all

all: deps
	webpack $(WFLAGS)

prod: deps
	NODE_ENV=production webpack $(WFLAGS)

watch: deps
	webpack $(WFLAGS) --watch

deps:
	[[ -f bower.json ]] && bower install || true
	[[ -f package.json ]] && npm install || true

start:
	foreman start

run: watch

wsrun: ws
	exec ./nanosock

ws: wsdeps
	go build

wsdeps:
	go get -u github.com/gdamore/mangos
	go get -u golang.org/x/net/websocket

clean:
	rm -rf build dist

contributors:
	echo "Contributors to nanosock, both large and small:\n" > CONTRIBUTORS
	git log --raw | grep "^Author: " | sort | uniq | cut -d ' ' -f2- | sed 's/^/- /' | cut -d '<' -f1 >> CONTRIBUTORS
