package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"github.com/patcoll/mangos/protocol/req"
	"github.com/patcoll/mangos/transport/ws"
	"golang.org/x/net/websocket"
)

var (
	err error
)

var bogusstr = "THIS IS BOGUS"

func bogusHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, bogusstr)
}

// Echo the data received on the WebSocket.
func EchoServer(ws *websocket.Conn) {
	io.Copy(ws, ws)
}

func main() {
	transport := ws.NewTransport()
	addr := "ws://127.0.0.1:3333/mysock"
	listener, err := transport.Listener(addr, req.NewProtocol())
	listener.Handle("/", http.FileServer(http.Dir("www")))
	listener.Handle("/echo", websocket.Handler(EchoServer))
	listener.Handle("/sock", listener)
	listener.HandleFunc("/bogus", bogusHandler)

	if err = listener.Listen(); err != nil {
		log.Fatal("Listen:", err)
		log.Fatal(err)
	}
	log.Println("serving: ", addr)
	<-listener.Done()
	log.Println("end.")
}
