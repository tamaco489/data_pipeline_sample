package repository

import (
	"context"
	"database/sql"
	"fmt"
	"log/slog"
	"sync"
	"time"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/configuration"

	mysql_driver "github.com/go-sql-driver/mysql"
)

// Beginner is a interface that defines the BeginTx method.
type Beginner interface {
	BeginTx(ctx context.Context, opts *sql.TxOptions) (*sql.Tx, error)
}

// Check if the Beginner interface defines methods for sql.DB
var _ Beginner = (*sql.DB)(nil)

var (
	instance *sql.DB
	once     sync.Once
)

// InitDB initializes a MySQL instance.
func InitDB() *sql.DB {
	var err error
	once.Do(func() {
		instance, err = connect()
		if err != nil {
			panic(err)
		}
	})
	return instance
}

// connect connects to a MySQL instance.
func connect() (*sql.DB, error) {
	c := mysql_driver.Config{
		User:                 configuration.Get().CoreDB.User,
		Passwd:               configuration.Get().CoreDB.Pass,
		Addr:                 fmt.Sprintf("%s:%s", configuration.Get().CoreDB.Host, configuration.Get().CoreDB.Port),
		DBName:               configuration.Get().CoreDB.Name,
		ParseTime:            true,
		Net:                  "tcp",
		AllowNativePasswords: true,
	}

	db, err := sql.Open("mysql", c.FormatDSN())
	if err != nil {
		return nil, err
	}

	// set connection pool
	lifetime := 1 * time.Minute
	if configuration.Get().API.Env == "stg" {
		lifetime = 10 * time.Second
	}

	db.SetMaxOpenConns(2)
	db.SetMaxIdleConns(0)
	db.SetConnMaxLifetime(lifetime)

	slog.Info("[debug: mysql connected]", "host", configuration.Get().CoreDB.Host, "port", configuration.Get().CoreDB.Port, "dbname", configuration.Get().CoreDB.Name)

	return db, err
}
