package modules

import (
	"encoding/json"
	"fmt"

	"github.com/gorilla/websocket"
)

// Module - a Module for the Smart Mirror
type Module interface {
	Run(ws *websocket.Conn) bool
}

func sendModule(ws *websocket.Conn, module Module) {

	wsObj := map[string]Module{
		"module": module,
	}
	jsonMessage, _ := json.Marshal(wsObj)
	err := ws.WriteMessage(websocket.TextMessage, jsonMessage)

	if err != nil {
		fmt.Println(err)
		return
	}
}
