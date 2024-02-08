package infrastructure

import (
	"context"
	"net/http"

	"github.com/jmoiron/sqlx"
)

func AddDbInContextMiddleware(db *sqlx.DB) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			new_req := r.WithContext(context.WithValue(r.Context(), "db", db))
			next.ServeHTTP(w, new_req)
		})
	}
}
