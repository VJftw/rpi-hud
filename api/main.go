package main

import (
	"log"
	"net/http"

	"github.com/facebookgo/inject"
)

// RPIHudApp - base app struct
type RPIHudApp struct {
	Router *Router `inject:""`
}

func (app *RPIHudApp) init() {
	app.Router.init()
}

func main() {
	var app RPIHudApp

	inject.Populate(&app)
	app.init()

	log.Fatal(http.ListenAndServe(":8080", app.Router.GetRouter()))
}
