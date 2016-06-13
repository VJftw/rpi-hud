package controllers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"github.com/vjftw/rpi-hud/api/modules"
)

// WSHudController -
type WSHudController struct {
}

// AddRoutes - adds routes that this controller handles
func (wsHC *WSHudController) AddRoutes(r *mux.Router) {
	r.
		HandleFunc("/ws/v1/hud", wsHC.wsHudHandler)
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

func (wsHC *WSHudController) wsHudHandler(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatal(err)
		return
	}

	go monitorClose(ws)

	weatherModule := modules.WeatherModule{}
	go weatherModule.Run(ws)
}

func monitorClose(ws *websocket.Conn) {
	for {
		_, _, err := ws.ReadMessage()
		if err != nil {
			fmt.Println(err)
			fmt.Println("Closing WebSocket")
			ws.Close()
			return
		}
	}
}
