package models

import (
	"time"

	"github.com/gofrs/uuid/v5"
)

type Instance struct {
	Id        uuid.UUID
	Header    string
	Body      string
	Date      time.Time
	Completed bool
}
