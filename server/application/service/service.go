package service

import (
	"server/application/models"

	"github.com/gofrs/uuid/v5"
	"github.com/jmoiron/sqlx"
)

func Create(db *sqlx.DB, atom *models.Instance) error {
	atom.Id = uuid.Must(uuid.NewV4())
	_, err := db.NamedExec(`INSERT INTO dbo.Atoms (id, header, body, [date], completed) VALUES (:id,  :header, :body, :date, :completed)`, atom)

	return err
}
