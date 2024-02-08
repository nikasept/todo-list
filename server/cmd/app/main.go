package main

import (
	"fmt"
	"log"
	"net/http"
	"server/application"
	"server/application/infrastructure"

	"github.com/jmoiron/sqlx"
	_ "github.com/microsoft/go-mssqldb"
)

func main() {
	db, err := sqlx.Open("mssql", "server=localhost;user id=SA; password=putStrLn $ p2ssw0rd; database=projects;")
	if err != nil {
		log.Fatalln(err)
	}

	create_handler := infrastructure.AddDbInContextMiddleware(db)(http.HandlerFunc(application.Create))
	createHandlerWithContext, ok := create_handler.(http.HandlerFunc)

	if !ok {
		log.Fatalln("can't cast to http.HandlerFunc")
	}
	// /create [exact match]
	// /create/ [non-exact match]
	http.HandleFunc("GET /test", func(w http.ResponseWriter, r *http.Request) { fmt.Fprintln(w, "This is a message.") })
	http.HandleFunc("GET /create", createHandlerWithContext)
	http.ListenAndServe(":7000", nil)

	defer func() {
		if p := recover(); p != nil {
			log.Fatalln(p)
		}
	}()
}
