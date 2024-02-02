package main

import (
	"context"
	"log"
	"time"

	"github.com/jmoiron/sqlx"
)

// 1-2-2024
// I should implement this

var db *sqlx.DB

const (
	driverName         = "mssql"
	projectsConnection = "server=localhost;user id=SA;password=putStrLn $ p2ssw0rd;database=projects; port=1433; database=projects"
)

type Atom struct {
	Id          int
	Title       string
	Description string
	CreateDate  time.Time
}

type CreateAtom struct {
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Created_at  time.Time `json:"created_at"`
}

type AtomRepository interface {
	Create(a *Atom) error
	Get(id int) (*Atom, error)
	Update(a *Atom) error
	Delete(id int) error
	List() ([]*Atom, error)
	Count() (int, error)
	FindByHeader(header string) ([]*Atom, error)
	FindByAuthor(author string) ([]*Atom, error)
	FindByBody(body string) ([]*Atom, error)
	FindByBlogId(blogId int) ([]*Atom, error)
}

func InitDb() error {
	var err error
	db, err = sqlx.Open(driverName, projectsConnection)
	// what does this imply?
	db.SetMaxOpenConns(1)
	if err != nil {
		return err
	}

	return nil
}

func (a *CreateAtom) Create() error {

	// I should look into how context works
	ctx := context.Background()
	tx, _ := db.BeginTx(ctx, nil)

	query := `INSERT INTO todo.Atoms (title, description, createDate) VALUES (?, ?, ?)`
	res, err := tx.Exec(query, a.Title, a.Description, a.Created_at)
	if err != nil {
		return err
	}
	tx.Commit()

	log.Println(res)

	return nil
}
