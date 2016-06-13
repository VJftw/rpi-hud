package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/justinas/alice"
	"github.com/rs/cors"
	"github.com/vjftw/rpi-hud/api/controllers"
)

// Router - routes requests
type Router struct {
	WSHudController *controllers.WSHudController `inject:""`
	router          http.Handler
}

func (r *Router) init() {
	router := mux.NewRouter()

	router.HandleFunc("/", handler)
	r.WSHudController.AddRoutes(router)

	corsHandler := cors.Default()
	chain := alice.New(corsHandler.Handler)

	r.router = chain.Then(router)
}

// GetRouter - Returns the router
func (r *Router) GetRouter() http.Handler {
	return r.router
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello, world!")
}
