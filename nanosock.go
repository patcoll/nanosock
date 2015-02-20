package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	// "net/url"
	// "time"
	// "github.com/gdamore/mangos"
	// "github.com/gdamore/mangos/protocol/rep"
	// "github.com/gdamore/mangos/transport/ws"
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
	// transport := ws.NewTransport()
  //
	// sock, err := rep.NewSocket()
	// if err != nil {
	// 	panic("no socket")
	// }
	// defer sock.Close()
  //
	// sock.AddTransport(transport)
  //
	// listener, err := transport.NewListener("ws://127.0.0.1:3333/mysock", rep.NewProtocol())
	// if err != nil {
	// 	panic("no listener")
	// }
	// muxi, err := listener.GetOption(ws.OptionWebSocketMux)
	// if err != nil {
	// 	panic("no mux")
	// }
	// mux := muxi.(*http.ServeMux)
	// mux := http.NewServeMux()
	// mux.Handle("/", http.FileServer(http.Dir("www")))
	// mux.HandleFunc("/bogus", bogusHandler)
	// mux.Handle("/echo", websocket.Handler(EchoServer))

	http.Handle("/", http.FileServer(http.Dir("www")))
	// http.Handle("/echo", websocket.Handler(EchoServer))
	// http.Handle(wsUrl.Path, webSocketHandler)

	// go http.ListenAndServe("127.0.0.1:3333", mux)
	http.ListenAndServe("127.0.0.1:3334", nil)

	// if err = listener.Listen(); err != nil {
	// 	panic(err)
	// }

	// staticMsg := "hi from server"
	// for {
	// 	if msg, err := sock.RecvMsg(); err == mangos.ErrClosed {
	// 		break
	// 	} else {
	// 		log.Printf("received message: %v\n", msg)
	// 		log.Printf("sending: %v\n", staticMsg)
	// 		if err = sock.Send([]byte(staticMsg)); err != nil {
	// 			log.Printf("sent.\n")
	// 		}
	// 	}
	// }
	log.Println("end.")
}
