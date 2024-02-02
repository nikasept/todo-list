package main

import (
	"fmt"
	"html/template"
	"net/http"
	"time"
)

type ApiServer struct {
	addr string
}

func (s *ApiServer) Start() error {
	mux := http.NewServeMux()
	mux.HandleFunc("/", Index)
	mux.HandleFunc("/api/create", Create)

	err := http.ListenAndServe(s.addr, mux)
	if err != nil {
		return err
	}

	return nil
}

func Index(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		val, _ := template.New("hello world").Parse("{{.Title}} items are made of {{.Description}}")
		val.Execute(w, Atom{Title: "Repla", Description: "ce"})
		fmt.Fprintln(w, val.Name())

	default:
		fmt.Fprintf(w, "Not supported")
	}
}

func Create(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		atom := CreateAtom{Title: "DatabaseTest", Description: "I'm testing a database", Created_at: time.Now()}
		atom.Create()
		fmt.Fprintf(w, "Successfully created!")
	default:
		fmt.Fprintf(w, "Not supported")
	}
}
