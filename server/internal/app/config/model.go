package config

import (
	"context"
	"errors"
	"strings"

	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gorm.io/gorm/schema"

	"github.com/honmaple/maple-file/server/internal/app/serializer"
)

type DB struct {
	*gorm.DB
}

type Table struct {
	Name  string
	Model any
}

func (db *DB) WithContext(ctx context.Context) *DB {
	return &DB{db.DB.WithContext(ctx)}
}

func (db *DB) AutoMigrate(dst ...any) (err error) {
	for _, m := range dst {
		if table, ok := m.(*Table); ok {
			err = db.DB.Table(table.Name).AutoMigrate(table.Model)
		} else {
			err = db.DB.AutoMigrate(m)
		}
		if err != nil {
			return err
		}
	}
	return
}

func NewDB(conf *Config) (*DB, error) {
	var (
		db  *gorm.DB
		err error
		dsn = conf.GetString(DatabaseDSN)
	)
	gcfg := &gorm.Config{
		Logger: logger.Default,
		NamingStrategy: &schema.NamingStrategy{
			SingularTable: false,
		},
		DisableForeignKeyConstraintWhenMigrating: true,
	}
	switch {
	case strings.HasPrefix(dsn, "mysql://"):
		db, err = gorm.Open(mysql.Open(dsn[8:]), gcfg)
	case strings.HasPrefix(dsn, "sqlite://"):
		db, err = gorm.Open(sqlite.Open(dsn[9:]), gcfg)
	case strings.HasPrefix(dsn, "postgres://"):
		db, err = gorm.Open(postgres.Open(dsn[11:]), gcfg)
	default:
		return nil, errors.New("unknown or unsupported sql driver")
	}
	if err != nil {
		return nil, err
	}

	if conf.GetBool(DatabaseEcho) {
		db = db.Debug()
	}

	// db.Migrator().DropTable("taxonomy_terms")
	// db.Migrator().DropTable("note_terms")

	// m := db.Migrator()
	// tables, err := m.GetTables()
	// if err != nil {
	//	return nil, err
	// }
	// for _, table := range tables {
	//	if table == "repos" || table == "users" {
	//		continue
	//	}
	//	m.DropTable(table)
	// }

	schema.RegisterSerializer("protobuf_timestamp", serializer.ProtobufTimestamp{})

	db = db.Debug()
	return &DB{DB: db}, nil
}
