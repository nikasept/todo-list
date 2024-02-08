package application

import (
	"fmt"
	"net/http"
	"server/application/models"
	"server/application/service"
	"time"

	"github.com/jmoiron/sqlx"
)

func Create(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Entering create")
	db, ok := r.Context().Value("db").(*sqlx.DB)

	if !ok {
		http.Error(w, "db is required", http.StatusInternalServerError)
	}

	atom := models.Instance{Header: "Head", Body: "Body", Date: time.Now(), Completed: false}
	fmt.Printf("id: %s\n", atom.Id.String())
	err := service.Create(db, &atom)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	fmt.Fprintln(w, "created")
}
