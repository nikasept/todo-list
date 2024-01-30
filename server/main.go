package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"time"

	_ "server/docs"

	httpSwagger "github.com/swaggo/http-swagger"

	"github.com/jmoiron/sqlx"
	_ "github.com/microsoft/go-mssqldb"
)

type Repository interface {
	CreateBlogTable(s *Store) error
	DropBlogTable(s *Store) error
}

type Store struct {
	db *sqlx.DB
}

// @Tags hello v1
// @Accept json
func (s *Store) CreateBlogTable() error {
	var createBlogTable string = `
	CREATE TABLE Blogs
	(
		BlogId INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- primary key column
		Header VARCHAR(50) NOT NULL,
		Body VARCHAR(1024) NOT NULL,
		Author VARCHAR(255) NULL
		-- specify more columns here
	);
`
	_, err := s.db.Exec(createBlogTable)
	if err != nil {
		return err
	}
	return nil
}

func (s *Store) DropBlogTable() error {
	var dropBlogTable string = `
	IF EXISTS (
		SELECT *
			FROM sys.tables
			JOIN sys.schemas
				ON sys.tables.schema_id = sys.schemas.schema_id
		WHERE sys.schemas.name = N'dbo'
			AND sys.tables.name = N'Blogs'
	)
		DROP TABLE dbo.Blogs
`
	_, err := s.db.Exec(dropBlogTable)
	if err != nil {
		return err
	}
	return nil
}

type Blog struct {
	BlogId int            `mytag:"b"`
	Header string         `mytag:"h"`
	Body   string         `mytag:"bo"`
	Author sql.NullString `mytag:"a"`
}

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

	const (
		driverName         = "mssql"
		projectsConnection = "server=localhost;user id=SA;password=putStrLn $ p2ssw0rd;database=projects; port=1433; database=projects"
	)
	open, err := sql.Open(driverName, projectsConnection)
	if err != nil {
		log.Println(err)
		return
	}

	db := sqlx.NewDb(open, driverName)
	/*
		str := Store{db: db}
		str.CreateBlogTable()

		if err = str.CreateBlogTable(); err != nil {
			log.Println(err)
			return
		}
	*/

	db.MustExec(`
	INSERT INTO dbo.Blogs (Header, Body) VALUES ($2, $3)
	`, 5, "FirstHeader", "Firstbody")

	result, _ := db.Query(`
	SELECT * FROM dbo.Blogs
	`)

	var blog Blog
	for result.Next() {
		result.Scan(&blog.BlogId, &blog.Header, &blog.Body, &blog.Author)
		fmt.Println(blog)
		break
	}

	a := http.NewServeMux()
	a.Handle("/swagger/", httpSwagger.WrapHandler)
	a.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			fmt.Fprintf(w, time.Now().String())
		case http.MethodPost:
			fmt.Fprintf(w, "Hello, World!")
		case http.MethodPut:
			fmt.Fprintf(w, "Hello, World!")
		case http.MethodPatch:
			fmt.Fprintf(w, "Hello, World!")
		case http.MethodDelete:
			fmt.Fprintf(w, "Hello, World!")
		default:
			fmt.Fprintf(w, "Hello, World!")
		}
	})

	http.ListenAndServe("localhost:7000", a)

	//this is how reflection works in go
	/*
		t := reflect.TypeOf(blog)
		field, _ := t.FieldByName("Header")
		fmt.Println(field.Tag.Get("mytag"))
	*/

}
