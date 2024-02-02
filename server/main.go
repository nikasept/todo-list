package main

import (
	"log"

	_ "server/docs"

	_ "github.com/microsoft/go-mssqldb"
)

func main() {
	// if panic happens if defer is after the panic
	// it will not be added to the stack because execution stops
	// hence if we want to handle panics, we should probably add it
	// at the top of the funciton
	/*
		defer func() {
			if ex := recover(); ex != nil {
				fmt.Printf("recovered from panic: %v\n", ex)
			}
		}()
	*/

	InitDb()

	serv := ApiServer{addr: "localhost:7000"}
	err := serv.Start()
	if err != nil {
		log.Fatalln(err)
	}

	//this is how reflection works in go
	/*
		t := reflect.TypeOf(blog)
		field, _ := t.FieldByName("Header")
		fmt.Println(field.Tag.Get("mytag"))
	*/

}
